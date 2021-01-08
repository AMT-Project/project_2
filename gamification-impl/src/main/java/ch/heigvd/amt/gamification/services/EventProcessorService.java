package ch.heigvd.amt.gamification.services;

import ch.heigvd.amt.gamification.entities.*;
import ch.heigvd.amt.gamification.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Console;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class EventProcessorService {
    @Autowired
    private BadgeRepository badgeRepository;

    @Autowired
    private PointScaleRepository pointScaleRepository;

    @Autowired
    private BadgeRewardRepository badgeRewardRepository;

    @Autowired
    private PointRewardRepository pointRewardRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RuleRepository ruleRepository;

    public long processEvent(EventEntity eventEntity) {
        // TODO appUserID
        String eventUserId = eventEntity.getUserId(); // TODO : plutot userName que userID... et pourquoi pas utiliser ID ?
        ApplicationEntity applicationEntity = eventEntity.getApplicationEntity();

        // Récupère l'utilisateur à partir de l'Event
        UserEntity user = userRepository.findByAppUserIdAndApplicationEntity(eventUserId, applicationEntity);
        // S'il n'existe pas encore on le créé
        if(user == null) {
            user = new UserEntity();
            user.setAppUserId(eventUserId);
            user.setApplicationEntity(eventEntity.getApplicationEntity());
            user.setNbBadges(0);
            userRepository.save(user);
        }

        // Récupère la règle du premier palier pas encore obtenu
        List<RuleEntity> eventRulesOfType = ruleRepository.findAllByApplicationEntityAndEventTypeOrderByAmountToGetAsc(applicationEntity, eventEntity.getEventType());
        RuleEntity ruletoApply = null;
        BadgeEntity badgeEntityOfApp = null;
        BadgeRewardEntity isPossessed = null;
        for(RuleEntity ruleOfType : eventRulesOfType) {
             ruletoApply = ruleOfType;
             badgeEntityOfApp = badgeRepository.findByApplicationEntityAndName(applicationEntity, ruleOfType.getAwardBadge());
             System.out.println(ruleOfType.getAwardBadge());

             isPossessed = badgeRewardRepository.findByBadgeEntityAndUserEntity(badgeEntityOfApp, user);

             if(badgeEntityOfApp != null && isPossessed == null){
                 break;
             }
        }

        // Si on a déjà obtenu tous les badges de chaque palier on quitte
        if(isPossessed != null){
            return user.getId();
        }

            PointScaleEntity pointScaleEntityOfApp = pointScaleRepository.findByApplicationEntityAndName(applicationEntity, ruletoApply.getAwardPoints());
            int userPoints = 0;

            // Attribuer des points si la Rule l'indique
            if(pointScaleEntityOfApp != null) {
                // La règle attribue des points à l'utilisateur sur la pointScale définie
                PointRewardEntity pointRewardEntity = new PointRewardEntity();
                pointRewardEntity.setPointScaleEntity(pointScaleEntityOfApp);
                pointRewardEntity.setUserEntity(user);
                pointRewardEntity.setTimestamp(LocalDateTime.now());
                pointRewardEntity.setPoints(ruletoApply.getAmount());
                pointRewardRepository.save(pointRewardEntity);

                List<PointRewardEntity> userPointRewardEntityList = pointRewardRepository.findAllByUserEntityAndPointScaleEntity(user, pointScaleEntityOfApp);
                for(PointRewardEntity userPointRewardEntity : userPointRewardEntityList) {
                    userPoints += userPointRewardEntity.getPoints();
                }
            }

            // Attribue un badge si la Rule l'indique et si on le bon nombre de points
            if(badgeEntityOfApp != null && userPoints >= ruletoApply.getAmountToGet()) {
                // La règle attribue un badge à l'utilisateur
                BadgeRewardEntity badgeRewardEntity = new BadgeRewardEntity();
                badgeRewardEntity.setBadgeEntity(badgeEntityOfApp);
                badgeRewardEntity.setUserEntity(user);
                badgeRewardEntity.setTimestamp(LocalDateTime.now());
                badgeRewardRepository.save(badgeRewardEntity);

                // Incrémente le compteur de badges de l'utilisateur
                int nbBadges = user.getNbBadges();
                user.setNbBadges(++nbBadges);
                userRepository.save(user);
            }
        return user.getId();
    }
}
