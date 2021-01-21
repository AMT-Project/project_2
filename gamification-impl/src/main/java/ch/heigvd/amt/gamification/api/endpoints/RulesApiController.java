package ch.heigvd.amt.gamification.api.endpoints;

import ch.heigvd.amt.gamification.api.RulesApi;
import ch.heigvd.amt.gamification.api.model.*;
import ch.heigvd.amt.gamification.entities.ApplicationEntity;
import ch.heigvd.amt.gamification.entities.RuleEntity;
import ch.heigvd.amt.gamification.repositories.RuleRepository;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.servlet.ServletRequest;
import javax.validation.Valid;
import java.net.URI;
import java.util.List;

@Controller
public class RulesApiController implements RulesApi {
    @Autowired
    ServletRequest request;

    @Autowired
    RuleRepository ruleRepository;

    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<Void> createRule(@ApiParam(value = "", required = true) @Valid @RequestBody Rule rule) {
        //Controle avec quelle event la pointScale est liée
        List<RuleEntity> doesPointScaleExist = ruleRepository.findAllByAwardPoints(rule.getThen().getAwardPoints().getPointScale());
        System.out.println("doesPointScaleExist " + doesPointScaleExist);
        List<RuleEntity> rulesEventTypePS = null;
        if(doesPointScaleExist != null){
             rulesEventTypePS = ruleRepository.findAllByAwardPointsAndEventType(rule.getThen().getAwardPoints().getPointScale(), rule.getIf().getEventType());
        }
        System.out.println("rulesEventTypePS " + rulesEventTypePS);

        //Lie la pointScale avec l'eventType la première fois qu'on crée la règle avec
        boolean isPointScaleAlreadyUsed = false;
        if(doesPointScaleExist != null && doesPointScaleExist.size() !=0){
            isPointScaleAlreadyUsed =  rulesEventTypePS != null && rulesEventTypePS.size() == 0;
        }

        System.out.println("isPointScaleAlreadyUsed " + isPointScaleAlreadyUsed);

        // Controle si le pallier est bien unique pour la pointScale
        RuleEntity ruleStepPS = ruleRepository.findByAmountToGetAndAwardPoints(rule.getThen().getAwardPoints().getAmountToGet(), rule.getThen().getAwardPoints().getPointScale());

        if(isPointScaleAlreadyUsed
                || ruleStepPS != null
                || rule.getThen().getAwardPoints().getAmount() < 0 || rule.getThen().getAwardPoints().getAmount() > rule.getThen().getAwardPoints().getAmountToGet()
                || rule.getThen().getAwardPoints().getAmountToGet() == 0
                || rule.getThen().getAwardPoints().getAmountToGet() % rule.getThen().getAwardPoints().getAmount() != 0){
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        RuleEntity newRuleEntity = toRuleEntity(rule);
        newRuleEntity.setApplicationEntity((ApplicationEntity) request.getAttribute("applicationEntity"));
        ruleRepository.save(newRuleEntity);

        Long id = newRuleEntity.getId();

        URI location = ServletUriComponentsBuilder
            .fromCurrentRequest().path("/{id}")
            .buildAndExpand(newRuleEntity.getId()).toUri();

        return ResponseEntity.created(location).build();
    }

    private RuleEntity toRuleEntity(Rule rule) {
        RuleEntity entity = new RuleEntity();
        entity.setName(rule.getName());
        entity.setEventType(rule.getIf().getEventType());
        entity.setAwardBadge(rule.getThen().getAwardBadge());
        entity.setAwardPoints(rule.getThen().getAwardPoints().getPointScale());
        entity.setAmount(rule.getThen().getAwardPoints().getAmount());
        entity.setAmountToGet(rule.getThen().getAwardPoints().getAmountToGet());
        return entity;
    }

    private Rule toRule(RuleEntity entity) {
        Rule rule = new Rule();
        rule.setName(entity.getName());

        RuleIf ruleIf = new RuleIf();
        rule.setIf(ruleIf.eventType(entity.getEventType()));

        RuleThen ruleThen = new RuleThen();
        ruleThen.setAwardBadge(entity.getAwardBadge());

        RuleThenAwardPoints ruleThenAwardPoints = new RuleThenAwardPoints();
        ruleThenAwardPoints.setPointScale(entity.getAwardPoints());
        ruleThenAwardPoints.setAmount(entity.getAmount());
        ruleThenAwardPoints.setAmountToGet(entity.getAmountToGet());
        ruleThen.setAwardPoints(ruleThenAwardPoints);

        return rule;
    }
}
