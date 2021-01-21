package ch.heigvd.amt.gamification.api.spec.steps;

import ch.heigvd.amt.gamification.ApiException;
import ch.heigvd.amt.gamification.ApiResponse;
import ch.heigvd.amt.gamification.api.DefaultApi;
import ch.heigvd.amt.gamification.api.dto.*;
import ch.heigvd.amt.gamification.api.dto.Badge;
import ch.heigvd.amt.gamification.api.dto.Event;
import ch.heigvd.amt.gamification.api.dto.Rule;
import ch.heigvd.amt.gamification.api.dto.RuleIf;
import ch.heigvd.amt.gamification.api.dto.RuleThen;
import ch.heigvd.amt.gamification.api.dto.RuleThenAwardPoints;
import ch.heigvd.amt.gamification.api.dto.User;
import ch.heigvd.amt.gamification.api.spec.helpers.Environment;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import static org.junit.Assert.assertNotNull;

public class RuleSteps {
    private Environment environment;
    private DefaultApi api;

    private ApiResponse lastApiResponse;
    private String lastReceivedLocationHeader;

    private Rule lastReceivedRule;
    private Rule rule;

    private Event event;
    private User user;
    private Badge badge;


    public RuleSteps(Environment environment) {
        this.environment = environment;
        this.api = environment.getApi();
    }


    @Given("there is a Rules server")
    public void there_is_a_rules_server() {
        assertNotNull(api);
    }

    @Given("I have a rule payload")
    public void i_have_a_rule_payload() {
        rule = new ch.heigvd.amt.gamification.api.dto.Rule()
               .name("mockRuleName")
                ._if(new RuleIf()
                        .eventType("mockEventType"))
                .then(new RuleThen()
                    .awardBadge("mockBadgeName")
                    .awardPoints(new RuleThenAwardPoints()
                            .amount(10)
                            .amountToGet(20)
                            .pointScale("mockPointScaleName")
                ));
    }

    @When("I POST the rule payload to the \\/rules endpoint")
    public void i_post_the_rule_payload_to_the_rules_endpoint() {
        try {
            lastApiResponse = api.createRuleWithHttpInfo(rule);
            environment.processApiResponse(lastApiResponse);
        } catch (ApiException e) {
            environment.processApiException(e);
        }
    }

    @Then("I send a GET to the badges endpoint for URL in the userLocation header")
    public void i_send_a_get_to_the_badges_endpoint_for_url_in_the_user_location_header() {
        String lastReceivedUserLocationHeader = environment.getLastReceivedUserLocationHeader();
        String id = lastReceivedUserLocationHeader.substring(lastReceivedUserLocationHeader.lastIndexOf('/') + 1);
        try {
            lastApiResponse = api.getUserBadgesWithHttpInfo(id);
            environment.processApiResponse(lastApiResponse);
            //lastReceivedUser = (ch.heigvd.amt.gamification.api.dto.User) lastApiResponse.getData();
        } catch(ApiException e) {
            environment.processApiException(e);
        }
    }

    @Given("I have an event payload for event {string} user {string}")
    public void i_have_an_event_payload_for_event_user(String type, String userId) {
        event = new Event()
                .eventType(type)
                .appUserId(userId);

        user = new User().appUserId(userId);
    }

    @Given("I have a rule payload if {string} then award badge {string}")
    public void i_have_a_rule_payload_if_then_award_badge(String type, String badge) {
        rule = new ch.heigvd.amt.gamification.api.dto.Rule()
                .name("rule_" + type + "_" + badge)
                ._if(new RuleIf()
                        .eventType(type))
                .then(new RuleThen()
                        .awardBadge(badge)
                        .awardPoints(new RuleThenAwardPoints()
                                .amount(10)
                                .amountToGet(20)
                                .pointScale("mockPointScaleName"))
                        );
    }

    //TODO REFACTOR
    @When("I POST the event payload to the \\/events endpoint for rule")
    public void i_post_the_event_payload_to_the_events_endpoint_rule() {
        try {
            lastApiResponse = api.createEventWithHttpInfo(event);
            environment.processApiResponse(lastApiResponse);
        } catch(ApiException e) {
            environment.processApiException(e);
        }
    }

    @When("I have successfully registered a badge named {string}")
    public void i_have_successfully_registered_a_badge_named(String name) {
        badge = new ch.heigvd.amt.gamification.api.dto.Badge()
                .name(name)
                .description("mockdesc");
        try {
            lastApiResponse = api.createBadgeWithHttpInfo(badge);
            environment.processApiResponse(lastApiResponse);
        } catch (ApiException e) {
            environment.processApiException(e);
        }
    }

}
