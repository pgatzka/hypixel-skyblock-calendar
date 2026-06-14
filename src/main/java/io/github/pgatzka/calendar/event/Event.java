package io.github.pgatzka.calendar.event;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

/**
 * A Hypixel Skyblock in-game event. All instants are stored in UTC; recurrence is modelled as a
 * nullable RFC 5545 RRULE string that the MVP leaves null (single events only).
 */
@Entity
@Table(name = "events")
public class Event {

  @Id
  @GeneratedValue(strategy = GenerationType.UUID)
  @Column(nullable = false, updatable = false)
  private UUID id;

  @Column(nullable = false)
  private String title;

  @Column private String description;

  @Column private String category;

  @Column(name = "start_time", nullable = false)
  private Instant startTime;

  @Column(name = "duration_minutes", nullable = false)
  private int durationMinutes;

  /** RFC 5545 recurrence rule. Null for single (non-recurring) events; unused in the MVP. */
  @Column(name = "recurrence_rule")
  private String recurrenceRule;

  @CreationTimestamp
  @Column(name = "created_at", nullable = false, updatable = false)
  private Instant createdAt;

  @UpdateTimestamp
  @Column(name = "updated_at", nullable = false)
  private Instant updatedAt;

  /** JPA requires a no-arg constructor. */
  protected Event() {}

  public Event(
      String title,
      String description,
      String category,
      Instant startTime,
      int durationMinutes,
      String recurrenceRule) {
    this.title = title;
    this.description = description;
    this.category = category;
    this.startTime = startTime;
    this.durationMinutes = durationMinutes;
    this.recurrenceRule = recurrenceRule;
  }

  public UUID getId() {
    return id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getCategory() {
    return category;
  }

  public void setCategory(String category) {
    this.category = category;
  }

  public Instant getStartTime() {
    return startTime;
  }

  public void setStartTime(Instant startTime) {
    this.startTime = startTime;
  }

  public int getDurationMinutes() {
    return durationMinutes;
  }

  public void setDurationMinutes(int durationMinutes) {
    this.durationMinutes = durationMinutes;
  }

  public String getRecurrenceRule() {
    return recurrenceRule;
  }

  public void setRecurrenceRule(String recurrenceRule) {
    this.recurrenceRule = recurrenceRule;
  }

  public Instant getCreatedAt() {
    return createdAt;
  }

  public Instant getUpdatedAt() {
    return updatedAt;
  }
}
