package io.github.pgatzka.calendar.health;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/** Liveness endpoint used by the frontend and CI to confirm the app is up. */
@RestController
public class HealthController {

  /** Simple status payload. */
  public record HealthResponse(String status) {}

  @GetMapping("/api/health")
  public HealthResponse health() {
    return new HealthResponse("UP");
  }
}
