# UChicago Exam Scheduler

A web platform that helps UChicago students easily lookup final exam times and save them as calendar events. Built with React frontend and Spring Boot backend.

## Features

- 🔍 **Easy Exam Lookup**: Search by class time (e.g., "8:30 MWF") or course code (e.g., "CMSC 23200")
- 📅 **Calendar Integration**: Export exam schedules as .ics files for Google Calendar, Outlook, or any calendar app
- 🛒 **Shopping Cart**: Add multiple exams to your cart before exporting
- 🏷️ **Custom Labels**: Add custom labels to your calendar events
- 🚀 **Fast & Responsive**: Modern React UI with Spring Boot API

## Tech Stack

- **Frontend**: React 18, JavaScript
- **Backend**: Spring Boot 3.2.5, Java
- **Containerization**: Docker & Docker Compose
- **Deployment**: Kubernetes (with HPA for auto-scaling)
- **Monitoring**: Prometheus & Grafana

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Java 17+ (for local development)
- Node.js 16+ (for local development)

### Running with Docker (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/uchicago-exam-scheduler.git
   cd uchicago-exam-scheduler
   ```

2. Build and run everything:
   ```bash
   docker-compose up --build
   ```

3. Visit [http://localhost:3000](http://localhost:3000)

### Local Development

#### Backend Setup
```bash
cd backend
./mvnw spring-boot:run
```

#### Frontend Setup
```bash
cd frontend
npm install
npm start
```

## Usage

1. **Enter your class time** (e.g., "8:30 MWF" or "CMSC 23200")
2. **Click "Lookup"** to find the exam time
3. **Add a label** for your calendar event
4. **Click "Add to Cart"** to save it
5. **Repeat** for all your classes
6. **Click "Export to Calendar (.ics)"** to download the file
7. **Import** the .ics file into your preferred calendar app

## API Endpoints

- `GET /api/exam-time?classTime={classTime}` - Lookup exam time for a class

## Deployment

### Docker Deployment

The application is containerized and ready for deployment:

```bash
# Build images
docker build -t exam-scheduler-backend:latest ./backend
docker build -t exam-scheduler-frontend:latest ./frontend

# Run with docker-compose
docker-compose up -d
```

### Kubernetes Deployment

For production deployment on Kubernetes:

```bash
# Apply Kubernetes manifests
kubectl apply -f k8s/

# Check deployment status
kubectl get pods,services,ingress
```

The Kubernetes setup includes:
- Horizontal Pod Autoscaler (HPA) for auto-scaling
- Load balancer service
- Prometheus monitoring
- Grafana dashboards

### Cloud Deployment Options

#### Google Cloud Platform (GCP)
```bash
# Deploy to Google Cloud Run
gcloud run deploy exam-scheduler --source .

# Or use Google Kubernetes Engine (GKE)
gcloud container clusters create exam-scheduler-cluster
kubectl apply -f k8s/
```

#### AWS
```bash
# Deploy to AWS ECS
aws ecs create-cluster --cluster-name exam-scheduler
# ... configure ECS task definitions

# Or use Amazon EKS
eksctl create cluster --name exam-scheduler-cluster
kubectl apply -f k8s/
```

#### Azure
```bash
# Deploy to Azure Container Instances
az container create --resource-group exam-scheduler --name exam-scheduler --image exam-scheduler:latest

# Or use Azure Kubernetes Service (AKS)
az aks create --resource-group exam-scheduler --name exam-scheduler-cluster
kubectl apply -f k8s/
```

## Project Structure

```
ExamSchedule/
├── backend/                 # Spring Boot API
│   ├── src/main/java/      # Java source code
│   ├── Dockerfile          # Backend container
│   └── pom.xml            # Maven dependencies
├── frontend/               # React application
│   ├── src/               # React components
│   ├── Dockerfile         # Frontend container
│   └── package.json       # Node.js dependencies
├── k8s/                   # Kubernetes manifests
├── monitoring/            # Prometheus & Grafana configs
├── docker-compose.yml     # Local development setup
└── README.md             # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please open an issue on GitHub or contact the development team.

## Roadmap

- [ ] Add more exam data for different quarters
- [ ] Implement user accounts and saved schedules
- [ ] Add mobile app support
- [ ] Integration with UChicago course catalog API
- [ ] Push notifications for exam reminders
- [ ] Conflict detection for overlapping exams
