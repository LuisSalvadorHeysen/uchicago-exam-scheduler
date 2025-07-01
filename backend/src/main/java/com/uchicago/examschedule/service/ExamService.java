package com.uchicago.examschedule.service;

import com.uchicago.examschedule.model.Exam;
import com.uchicago.examschedule.repository.ExamRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ExamService {
    @Autowired
    private ExamRepository examRepo;

    @Cacheable("exams")
    public List<Exam> getExamsByCourse(String courseCode) {
        return examRepo.findByCourseCode(courseCode);
    }
}
