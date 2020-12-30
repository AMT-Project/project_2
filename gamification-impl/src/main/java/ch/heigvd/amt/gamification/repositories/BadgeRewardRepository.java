package ch.heigvd.amt.gamification.repositories;

import ch.heigvd.amt.gamification.entities.BadgeEntity;
import ch.heigvd.amt.gamification.entities.BadgeRewardEntity;
import ch.heigvd.amt.gamification.entities.UserEntity;
import org.springframework.data.repository.CrudRepository;

public interface BadgeRewardRepository extends CrudRepository<BadgeRewardEntity, Long> {
    //List<BadgeRewardEntity> findAllByUserEntity(UserEntity userEntity);
    //BadgeEntity findByApplicationEntityAndName(ApplicationEntity applicationEntity, String name);

    BadgeRewardEntity findByBadgeEntityAndUserEntity(BadgeEntity badgeEntity, UserEntity userEntity);
}