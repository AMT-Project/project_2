package ch.heigvd.amt.gamification.entities;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Data
public class UserEntity implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String appUserId;
    private int nbBadges;

    private ApplicationEntity applicationEntity;
}
