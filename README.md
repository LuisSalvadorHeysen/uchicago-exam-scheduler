# UChicago Exam Scheduler

A simple web application that helps UChicago students easily lookup final exam times and save them as calendar events. Built with vanilla HTML, CSS, and JavaScript.

## Features

- 🔍 **Easy Exam Lookup**: Search by class time (e.g., "8:30 MWF") or course code (e.g., "CMSC 23200")
- 📅 **Calendar Integration**: Export exam schedules as .ics files for Google Calendar, Outlook, or any calendar app
- 🛒 **Shopping Cart**: Add multiple exams to your cart before exporting
- 🏷️ **Custom Labels**: Add custom labels to your calendar events
- 🚀 **No Dependencies**: Pure HTML/CSS/JavaScript - no build process required

## Quick Start

### Option 1: Simple Local Deployment (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/LuisSalvadorHeysen/uchicago-exam-scheduler.git
   cd uchicago-exam-scheduler
   ```

2. Open `index.html` in your web browser:
   ```bash
   # On Linux/Mac
   open index.html
   
   # Or simply double-click the file in your file manager
   ```

3. That's it! The application is ready to use.

### Option 2: Using a Local Server

For better development experience, you can serve the files using a local server:

```bash
# Using Python 3
python3 -m http.server 8000

# Using Python 2
python -m SimpleHTTPServer 8000

# Using Node.js (if you have it installed)
npx http-server

# Using PHP
php -S localhost:8000
```

Then visit `http://localhost:8000` in your browser.

## Usage

1. **Enter your class time** (e.g., "8:30 MWF" or "CMSC 23200")
2. **Add a label** for your calendar event
3. **Click "Add to Cart"** to save it
4. **Repeat** for all your classes
5. **Click "Export to Calendar (.ics)"** to download the file
6. **Import** the .ics file into your preferred calendar app

## Supported Class Times

The application includes mappings for:
- MWF classes: 8:30, 9:30, 10:30, 11:30, 12:30, 1:30, 2:30, 3:30, 4:30+
- TUTH classes: 8-9:20, 9:30-10:50, 11-12:20, 12:30-1:50, 2:00-3:20, 3:30-4:50, 5:00+
- Specific courses: CMSC 23200, CMSC 23500, CMSC 28000, MATH 13300, etc.
- General Chemistry and Honors General Chemistry
- Combined Language Exams
- Available slots for other courses

## Deployment Options

### Static Hosting (Recommended)

Since this is a static HTML application, you can deploy it to any static hosting service:

#### GitHub Pages
```bash
# Push to GitHub and enable GitHub Pages in repository settings
git push origin main
```

#### Netlify
```bash
# Drag and drop the index.html file to Netlify
# Or connect your GitHub repository
```

#### Vercel
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

#### AWS S3 + CloudFront
```bash
# Upload files to S3 bucket and configure CloudFront
aws s3 sync . s3://your-bucket-name --exclude ".git/*"
```

#### Google Cloud Storage
```bash
# Upload to Google Cloud Storage
gsutil cp index.html gs://your-bucket-name/
gsutil iam ch allUsers:objectViewer gs://your-bucket-name/
```

### Docker Deployment (Optional)

If you prefer containerized deployment:

```bash
# Build and run with Docker
docker build -t exam-scheduler .
docker run -p 8080:80 exam-scheduler

# Or use docker-compose
docker-compose up
```

## Project Structure

```
ExamSchedule/
├── index.html              # Main application (HTML + CSS + JavaScript)
├── exams.json              # Exam data (alternative data source)
├── SpringFinalExams2025.xlsx # Original Excel data
├── process_excel.py        # Script to process Excel data
├── create_structure.py     # Script to create project structure
├── frontend/               # React version (alternative implementation)
├── backend/                # Spring Boot version (alternative implementation)
├── k8s/                    # Kubernetes manifests (for containerized deployment)
├── monitoring/             # Monitoring configs (for production deployment)
└── README.md              # This file
```

## Development

### Adding New Exam Times

To add new exam times, edit the `examTimes` object in `index.html`:

```javascript
const examTimes = {
  "8:30 mwf": "WED 10:00 AM–12:00 PM",
  "your new class": "DAY TIME–TIME",
  // ... add more mappings
};
```

### Processing Excel Data

If you have new exam data in Excel format:

```bash
python3 process_excel.py SpringFinalExams2025.xlsx
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

For support, please open an issue on GitHub.

## Roadmap

- [ ] Add more exam data for different quarters
- [ ] Add search/filter functionality
- [ ] Improve mobile responsiveness
- [ ] Add dark mode
- [ ] Add exam conflict detection
- [ ] Integration with UChicago course catalog API
