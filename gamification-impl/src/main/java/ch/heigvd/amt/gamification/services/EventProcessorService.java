package ch.heigvd.amt.gamification.services;

import ch.heigvd.amt.gamification.entities.*;
import ch.heigvd.amt.gamification.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.Console;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

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
        String eventAppUserId = eventEntity.getAppUserId();
        ApplicationEntity applicationEntity = eventEntity.getApplicationEntity();

        // Récupère l'utilisateur à partir de l'Event
        UserEntity user = userRepository.findByAppUserIdAndApplicationEntity(eventAppUserId, applicationEntity);
        // S'il n'existe pas encore on le créé
        if(user == null) {
            user = new UserEntity();
            user.setAppUserId(eventAppUserId);
            user.setApplicationEntity(eventEntity.getApplicationEntity());
            user.setNbBadges(0);
            userRepository.save(user);
        }

        // Récupère la règle du premier palier pas encore obtenu
        List<RuleEntity> eventRulesOfType = ruleRepository.findAllByApplicationEntityAndEventTypeOrderByAmountToGetAsc(applicationEntity, eventEntity.getEventType());
        RuleEntity ruletoApply = null;
        BadgeEntity badgeEntityOfApp = null;
        int userPoints = 0;
        Set<String> pointscales = new HashSet<>();
        for(RuleEntity ruleOfType : eventRulesOfType) {
             ruletoApply = ruleOfType;
             PointScaleEntity pointScaleEntityOfApp = pointScaleRepository.findByApplicationEntityAndName(applicationEntity, ruletoApply.getAwardPoints());
             badgeEntityOfApp = badgeRepository.findByApplicationEntityAndName(applicationEntity, ruleOfType.getAwardBadge());
             System.out.println(ruleOfType.getAwardBadge());

            // Attribuer des points si la Rule l'indique
            if(pointScaleEntityOfApp != null) {
                userPoints = 0;
                // La règle attribue des points à l'utilisateur sur la pointScale définie
                PointRewardEntity pointRewardEntity = new PointRewardEntity();
                pointRewardEntity.setPointScaleEntity(pointScaleEntityOfApp);
                pointRewardEntity.setUserEntity(user);
                pointRewardEntity.setTimestamp(LocalDateTime.now());
                pointRewardEntity.setPoints(ruletoApply.getAmount());

                List<PointRewardEntity> userPointRewardEntityList = pointRewardRepository.findAllByUserEntityAndPointScaleEntity(user, pointScaleEntityOfApp);
                for (PointRewardEntity userPointRewardEntity : userPointRewardEntityList) {
                    userPoints += userPointRewardEntity.getPoints();
                }

                if (!pointscales.contains(ruletoApply.getAwardPoints()) && userPoints + ruleOfType.getAmount() <= ruletoApply.getAmountToGet()) {
                    pointRewardRepository.save(pointRewardEntity);
                    pointscales.add(ruletoApply.getAwardPoints());
                }
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
