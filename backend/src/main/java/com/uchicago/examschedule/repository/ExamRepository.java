package com.uchicago.examschedule.repository;

import com.uchicago.examschedule.model.Exam;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExamRepository extends JpaRepository<Exam, Long> {}
