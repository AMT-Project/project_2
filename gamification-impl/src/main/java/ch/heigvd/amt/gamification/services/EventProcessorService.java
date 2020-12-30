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
        // TODO APP
        String eventUserId = eventEntity.getUserId(); // TODO : plutot userName que userID... et pourquoi pas utiliser ID ?
        ApplicationEntity applicationEntity = eventEntity.getApplicationEntity();

        // Récupère l'utilisateur à partir de l'Event
        UserEntity user = userRepository.findByUserIdAndApplicationEntity(eventUserId, applicationEntity);
        // S'il n'existe pas encore on le créé
        if(user == null) {
            user = new UserEntity();
            user.setUserId(eventUserId);
            user.setApplicationEntity(eventEntity.getApplicationEntity());
            user.setNbBadges(0);
            userRepository.save(user);
        }

        // Récupère et parcourt la liste des Rules du type de l'Event
        List<RuleEntity> eventRulesOfType = ruleRepository.findAllByApplicationEntityAndEventTypeOrderByAmountToGetAsc(applicationEntity, eventEntity.getEventType());
        for(RuleEntity ruleOfType : eventRulesOfType) {

            BadgeEntity badgeEntityOfApp = badgeRepository.findByApplicationEntityAndName(applicationEntity, ruleOfType.getAwardBadge());

            //TODO : Checker que le user n'a pas déjà ce badge
            BadgeEntity isPossessed = badgeRewardRepository.findByBadgeEntityAndUserEntity(badgeEntityOfApp, user);

            PointScaleEntity pointScaleEntityOfApp = pointScaleRepository.findByApplicationEntityAndName(applicationEntity, ruleOfType.getAwardPoints());
            int userPoints = 0;

            // Attribuer des points si la Rule l'indique
            if(pointScaleEntityOfApp != null && isPossessed == null) {
                // La règle attribue des points à l'utilisateur sur la pointScale définie
                PointRewardEntity pointRewardEntity = new PointRewardEntity();
                pointRewardEntity.setPointScaleEntity(pointScaleEntityOfApp);
                pointRewardEntity.setUserEntity(user);
                pointRewardEntity.setTimestamp(LocalDateTime.now());
                pointRewardEntity.setPoints(ruleOfType.getAmount());
                pointRewardRepository.save(pointRewardEntity);

                System.out.println("POINTSSCALE ATTRIBUTION SUCCESSFULL");

                // TODO : Issue #37 - Vérifier le nombre de points de l'user et lui attribuer un badge s'il a atteint un palier de points
                List<PointRewardEntity> userPointRewardEntityList = pointRewardRepository.findAllByUserEntityAndPointScaleEntity(user, pointScaleEntityOfApp);
                //int userPoints = 0;
                for(PointRewardEntity userPointRewardEntity : userPointRewardEntityList) {
                    userPoints += userPointRewardEntity.getPoints();
                }
            }

            // Attribue un badge si la Rule l'indique
            if(badgeEntityOfApp != null && isPossessed == null && userPoints >= ruleOfType.getAmountToGet() ) {
                // La règle attribue un badge à l'utilisateur
                BadgeRewardEntity badgeRewardEntity = new BadgeRewardEntity();
                badgeRewardEntity.setBadgeEntity(badgeEntityOfApp);
                badgeRewardEntity.setUserEntity(user);
                badgeRewardEntity.setTimestamp(LocalDateTime.now());
                badgeRewardRepository.save(badgeRewardEntity);

                System.out.println("BADGES ATTRIBUTION SUCCESSFULL");

                // Incrémente le compteur de badges de l'utilisateur
                int nbBadges = user.getNbBadges();
                user.setNbBadges(++nbBadges);
                userRepository.save(user);
            }
        }
        return user.getId();
    }
}
