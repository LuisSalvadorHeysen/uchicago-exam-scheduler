package com.uchicago.examschedule.controller;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api")
public class ExamController {
    private static final Map<String, String> examTimes = new HashMap<>();
    static {
        examTimes.put("8:30 mwf", "WED 10:00 AM–12:00 PM");
        examTimes.put("cmsc 23200", "WED 10:00 AM–12:00 PM");
        // ... (add all mappings here)
    }

    @GetMapping("/exam-time")
    public Map<String, String> getExamTime(@RequestParam String classTime) {
        String key = classTime.trim().toLowerCase();
        String result = examTimes.getOrDefault(key, null);
        return Collections.singletonMap("examTime", result);
    }
}
