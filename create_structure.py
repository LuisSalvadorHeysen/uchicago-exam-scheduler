#!/usr/bin/env python3
import os

def create_project_structure():
    root = "/home/lsht/UChicago/Summer2026/Projects/ExamSchedule"
    structure = {
        "backend": {
            "src": {
                "main": {
                    "java": {
                        "com": {
                            "uchicago": {
                                "examschedule": {
                                    "ExamScheduleApplication.java": "package com.uchicago.examschedule;\n\nimport org.springframework.boot.SpringApplication;\nimport org.springframework.boot.autoconfigure.SpringBootApplication;\n\n@SpringBootApplication\npublic class ExamScheduleApplication {\n    public static void main(String[] args) {\n        SpringApplication.run(ExamScheduleApplication.class, args);\n    }\n}\n",
                                    "model": {
                                        "Course.java": "package com.uchicago.examschedule.model;\n\nimport jakarta.persistence.*;\n\n@Entity\npublic class Course {\n    @Id\n    @GeneratedValue(strategy = GenerationType.IDENTITY)\n    private Long id;\n    private String code;\n    private String title;\n    // Getters and setters\n}\n",
                                        "Exam.java": "package com.uchicago.examschedule.model;\n\nimport jakarta.persistence.*;\nimport java.time.LocalDateTime;\n\n@Entity\npublic class Exam {\n    @Id\n    @GeneratedValue(strategy = GenerationType.IDENTITY)\n    private Long id;\n    @ManyToOne\n    private Course course;\n    private LocalDateTime startTime;\n    private LocalDateTime endTime;\n    // Getters and setters\n}\n"
                                    },
                                    "repository": {
                                        "CourseRepository.java": "package com.uchicago.examschedule.repository;\n\nimport com.uchicago.examschedule.model.Course;\nimport org.springframework.data.jpa.repository.JpaRepository;\n\npublic interface CourseRepository extends JpaRepository<Course, Long> {}\n",
                                        "ExamRepository.java": "package com.uchicago.examschedule.repository;\n\nimport com.uchicago.examschedule.model.Exam;\nimport org.springframework.data.jpa.repository.JpaRepository;\n\npublic interface ExamRepository extends JpaRepository<Exam, Long> {}\n"
                                    },
                                    "service": {
                                        "ExamService.java": "package com.uchicago.examschedule.service;\n\nimport org.springframework.stereotype.Service;\n\n@Service\npublic class ExamService {\n    // Service implementation\n}\n"
                                    },
                                    "controller": {
                                        "ExamController.java": "package com.uchicago.examschedule.controller;\n\nimport org.springframework.web.bind.annotation.*;\n\n@RestController\n@RequestMapping(\"/api/exams\")\npublic class ExamController {\n    // Controller endpoints\n}\n"
                                    },
                                    "config": {
                                        "RateLimitFilter.java": "package com.uchicago.examschedule.config;\n\n// Rate limiting implementation\n"
                                    }
                                }
                            }
                        }
                    },
                    "resources": {
                        "application.properties": "spring.datasource.url=jdbc:postgresql://localhost:5432/examdb\nspring.datasource.username=postgres\nspring.datasource.password=postgres\n",
                        "data.sql": "-- Initial data SQL"
                    }
                }
            },
            "Dockerfile": "FROM eclipse-temurin:17-jdk\nWORKDIR /app\nCOPY . .\nRUN ./mvnw package\nCMD [\"java\", \"-jar\", \"target/*.jar\"]\n",
            "pom.xml": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<project>\n    <!-- Spring Boot pom.xml content -->\n</project>\n"
        },
        "frontend": {
            "public": {
                "index.html": "<!DOCTYPE html>\n<html>\n<head>\n    <title>UChicago Exam Scheduler</title>\n</head>\n<body>\n    <div id=\"root\"></div>\n</body>\n</html>"
            },
            "src": {
                "App.js": "import React from 'react';\n\nexport default function App() {\n    return <h1>Exam Scheduler</h1>;\n}",
                "index.js": "import React from 'react';\nimport ReactDOM from 'react-dom';\nimport App from './App';\n\nReactDOM.render(<App />, document.getElementById('root'));",
                "components": {
                    "ExamScheduler.jsx": "import React from 'react';\n\nexport default function ExamScheduler() {\n    return <div>Scheduler Component</div>;\n}",
                    "SearchBar.jsx": "import React from 'react';\n\nexport default function SearchBar() {\n    return <input placeholder=\"Search exams\" />;\n}",
                    "ExamList.jsx": "import React from 'react';\n\nexport default function ExamList() {\n    return <div>Exam List</div>;\n}",
                    "SelectedExamsList.jsx": "import React from 'react';\n\nexport default function SelectedExamsList() {\n    return <div>Selected Exams</div>;\n}"
                }
            },
            "Dockerfile": "FROM node:18\nWORKDIR /app\nCOPY package.json .\nRUN npm install\nCOPY . .\nCMD [\"npm\", \"start\"]\n",
            "package.json": "{\n  \"name\": \"exam-schedule-frontend\",\n  \"version\": \"1.0.0\",\n  \"dependencies\": {\n    \"react\": \"^18.2.0\",\n    \"react-dom\": \"^18.2.0\"\n  }\n}"
        },
        "db": {
            "init.sql": "CREATE TABLE courses (\n    id SERIAL PRIMARY KEY,\n    code VARCHAR(20) UNIQUE,\n    title VARCHAR(100)\n);\n\nCREATE TABLE exams (\n    id SERIAL PRIMARY KEY,\n    course_id INT REFERENCES courses(id),\n    start_time TIMESTAMP,\n    end_time TIMESTAMP\n);\n",
            "seed_exams.sql": "INSERT INTO courses (code, title) VALUES ('CMSC 23200', 'Intro to Computer Science');\n"
        },
        "docker-compose.yml": "version: '3.8'\n\nservices:\n  postgres:\n    image: postgres:15\n    environment:\n      POSTGRES_DB: examdb\n      POSTGRES_PASSWORD: postgres\n    ports:\n      - '5432:5432'\n\n  backend:\n    build: ./backend\n    ports:\n      - '8080:8080'\n    depends_on:\n      - postgres\n\n  frontend:\n    build: ./frontend\n    ports:\n      - '3000:3000'\n",
        "monitoring": {
            "prometheus.yml": "global:\n  scrape_interval: 15s\n\nscrape_configs:\n  - job_name: 'spring'\n    metrics_path: '/actuator/prometheus'\n    static_configs:\n      - targets: ['backend:8080']\n",
            "grafana": {
                "dashboards": {
                    "exam-scheduler.json": "{\"dashboard\": {\"title\": \"Exam Scheduler Metrics\"}}"
                }
            }
        },
        "k8s": {
            "exam-scheduler-deployment.yaml": "apiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: exam-scheduler\nspec:\n  replicas: 3\n  selector:\n    matchLabels:\n      app: exam-scheduler\n  template:\n    metadata:\n      labels:\n        app: exam-scheduler\n    spec:\n      containers:\n      - name: backend\n        image: exam-scheduler-backend:1.0.0\n",
            "exam-scheduler-service.yaml": "apiVersion: v1\nkind: Service\nmetadata:\n  name: exam-scheduler-service\nspec:\n  selector:\n    app: exam-scheduler\n  ports:\n    - protocol: TCP\n      port: 8080\n",
            "exam-scheduler-hpa.yaml": "apiVersion: autoscaling/v2\nkind: HorizontalPodAutoscaler\nmetadata:\n  name: exam-scheduler-hpa\nspec:\n  scaleTargetRef:\n    apiVersion: apps/v1\n    kind: Deployment\n    name: exam-scheduler\n  minReplicas: 2\n  maxReplicas: 10\n  metrics:\n  - type: Resource\n    resource:\n      name: cpu\n      target:\n        type: Utilization\n        averageUtilization: 50\n"
        },
        "README.md": "# UChicago Exam Schedule\n\nA comprehensive exam scheduling system.\n\n## Features\n- Spring Boot backend\n- React frontend\n- PostgreSQL database\n"
    }

    def create_directory(path, content):
        if isinstance(content, dict):
            os.makedirs(path, exist_ok=True)
            for name, sub_content in content.items():
                create_directory(os.path.join(path, name), sub_content)
        else:
            with open(path, 'w') as f:
                f.write(content)

    create_directory(root, structure)
    print("Successfully created project structure!")

if __name__ == "__main__":
    create_project_structure()

