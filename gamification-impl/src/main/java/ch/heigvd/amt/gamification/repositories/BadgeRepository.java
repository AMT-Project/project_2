package ch.heigvd.amt.gamification.repositories;

import ch.heigvd.amt.gamification.entities.ApplicationEntity;
import ch.heigvd.amt.gamification.entities.BadgeEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface BadgeRepository extends CrudRepository<BadgeEntity, Long> {

    List<BadgeEntity> findAllByApplicationEntity(ApplicationEntity applicationEntity);
    BadgeEntity findByApplicationEntityAndName(ApplicationEntity applicationEntity, String name);
}
