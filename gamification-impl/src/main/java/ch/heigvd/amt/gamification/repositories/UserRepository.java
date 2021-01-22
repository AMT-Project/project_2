package ch.heigvd.amt.gamification.repositories;

import ch.heigvd.amt.gamification.entities.ApplicationEntity;
import ch.heigvd.amt.gamification.entities.UserEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface UserRepository extends CrudRepository<UserEntity, Long> {

    List<UserEntity> findAllByApplicationEntity(ApplicationEntity applicationEntity);

    UserEntity findByAppUserId(String appUserId);

    UserEntity findByAppUserIdAndApplicationEntity(String appUserId, ApplicationEntity applicationEntity);
}
