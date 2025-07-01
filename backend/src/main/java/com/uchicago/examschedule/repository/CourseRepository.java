package com.uchicago.examschedule.repository;

import com.uchicago.examschedule.model.Course;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseRepository extends JpaRepository<Course, Long> {}
