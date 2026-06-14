package io.github.pgatzka.calendar.event;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

/** Spring Data repository for {@link Event}. */
public interface EventRepository extends JpaRepository<Event, UUID> {}
