package com.uchicago.examschedule.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Exam {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    private Course course;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    // Getters and setters
}
