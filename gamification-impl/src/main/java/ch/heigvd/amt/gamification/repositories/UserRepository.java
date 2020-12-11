package ch.heigvd.amt.gamification.repositories;

import ch.heigvd.amt.gamification.entities.ApplicationEntity;
import ch.heigvd.amt.gamification.entities.UserEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface UserRepository extends CrudRepository<UserEntity, Long> {

    List<UserEntity> findAllByApplicationEntity(ApplicationEntity applicationEntity);
    UserEntity findByUserId(String userId);
    // TODO : Optimiser en ne passant que l'applicationId et pas toute l'application?
    UserEntity findByUserIdAndApplicationEntity(String userId, ApplicationEntity applicationEntity);
}