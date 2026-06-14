package io.github.pgatzka.calendar.event;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Instant;
import java.time.LocalDateTime;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;

/**
 * Persistence round-trip against a real Postgres started by the docker-maven-plugin. Boots the full
 * context, so Flyway migrates and Hibernate validates the entity against the migrated schema. The
 * test JVM runs in a non-UTC zone (see the failsafe argLine) so the UTC assertions can actually
 * fail if {@code start_time} were mapped to a zone-less {@code timestamp}.
 */
@SpringBootTest
class EventPersistenceIT {

  @DynamicPropertySource
  static void datasource(DynamicPropertyRegistry registry) {
    String host = System.getProperty("postgres.host", "localhost");
    String port = System.getProperty("postgres.port");
    registry.add(
        "spring.datasource.url", () -> "jdbc:postgresql://" + host + ":" + port + "/calendar");
    registry.add("spring.datasource.username", () -> "calendar");
    registry.add("spring.datasource.password", () -> "calendar");
  }

  @Autowired private EventRepository events;
  @Autowired private JdbcTemplate jdbc;

  @Test
  void persistsAndReadsBackAllFieldsInUtc() {
    Instant start = Instant.parse("2026-06-14T20:00:00Z");

    Event saved =
        events.save(new Event("Spooky Festival", "Mobs drop candy", "festival", start, 60, null));

    Event found = events.findById(saved.getId()).orElseThrow();

    assertThat(found.getId()).isNotNull();
    assertThat(found.getTitle()).isEqualTo("Spooky Festival");
    assertThat(found.getDescription()).isEqualTo("Mobs drop candy");
    assertThat(found.getCategory()).isEqualTo("festival");
    assertThat(found.getStartTime()).isEqualTo(start);
    assertThat(found.getDurationMinutes()).isEqualTo(60);
    assertThat(found.getRecurrenceRule()).isNull();
    assertThat(found.getCreatedAt()).isNotNull();
    assertThat(found.getUpdatedAt()).isNotNull();

    // Defend AC #1 directly: read the raw column converted to UTC wall-clock. With a correct
    // timestamptz column this is 20:00 UTC regardless of the (non-UTC) JVM/session zone; a
    // zone-less timestamp column would have stored the local wall-clock and diverge here.
    LocalDateTime storedUtc =
        jdbc.queryForObject(
            "select start_time at time zone 'UTC' from events where id = ?",
            LocalDateTime.class,
            saved.getId());
    assertThat(storedUtc).isEqualTo(LocalDateTime.of(2026, 6, 14, 20, 0, 0));
  }
}
