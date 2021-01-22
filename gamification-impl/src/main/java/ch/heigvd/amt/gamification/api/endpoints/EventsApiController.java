package ch.heigvd.amt.gamification.api.endpoints;

import ch.heigvd.amt.gamification.api.EventsApi;
import ch.heigvd.amt.gamification.api.model.Event;
import ch.heigvd.amt.gamification.entities.ApplicationEntity;
import ch.heigvd.amt.gamification.entities.EventEntity;
import ch.heigvd.amt.gamification.services.EventProcessorService;
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

@Controller
public class EventsApiController implements EventsApi {
    @Autowired
    EventProcessorService eventProcessorService;

    @Autowired
    ServletRequest request;

    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<Void> createEvent(@ApiParam(value = "", required = true) @Valid @RequestBody Event event) {
        EventEntity newEventEntity = toEventEntity(event);
        newEventEntity.setApplicationEntity((ApplicationEntity) request.getAttribute("applicationEntity"));

        Long id = newEventEntity.getId();

        // Call to the Event Processor Service to handle events, set badges/pointScales and apply rules
        Long userId = eventProcessorService.processEvent(newEventEntity);

        String userAppId = newEventEntity.getAppUserId();

        URI location = ServletUriComponentsBuilder
            .fromCurrentRequest().path("/{id}")
            .buildAndExpand(newEventEntity.getId()).toUri();

        //URI userLocation = ServletUriComponentsBuilder.fromCurrentContextPath().path("/users").path("/{id}").buildAndExpand(userId).toUri();
        URI userLocation = ServletUriComponentsBuilder.fromCurrentContextPath().path("/users").path("/{id}").buildAndExpand(userAppId).toUri();

        return ResponseEntity.created(location).header("userLocation", userLocation.toString()).build();
    }

    private EventEntity toEventEntity(Event event) {
        EventEntity entity = new EventEntity();
        entity.setAppUserId(event.getAppUserId());
        entity.setTimestamp(event.getTimestamp());
        entity.setEventType(event.getEventType());
        return entity;
    }

    private Event toEvent(EventEntity entity) {
        Event event = new Event();
        event.setAppUserId(entity.getAppUserId());
        event.setTimestamp(entity.getTimestamp());
        event.setEventType(entity.getEventType());
        return event;
    }
}
