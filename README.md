# UChicago Exam Scheduler

## 🚀 Live Demo

Try the app online:  
[https://luissalvadorheysen.github.io/portfolio/exam-scheduler/](https://luissalvadorheysen.github.io/portfolio/exam-scheduler/)

---

A simple web application that helps UChicago students easily lookup final exam times and save them as calendar events.

## Features

- 🔍 **Easy Exam Lookup**: Search by class time (e.g., "8:30 MWF") or course code (e.g., "CMSC 23200")
- 📅 **Calendar Integration**: Export exam schedules as .ics files for Google Calendar, Outlook, or any calendar app
- 🛒 **Shopping Cart**: Add multiple exams to your cart before exporting
- 🏷️ **Custom Labels**: Add custom labels to your calendar events

## Quick Start

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

## Usage

1. **Enter your class time** (e.g., "8:30 MWF" or "CMSC 23200")
2. **Add a label** for your calendar event
3. **Click "Add to Cart"** to save it
4. **Repeat** for all your classes
5. **Click "Export to Calendar (.ics)"** to download the file
6. **Import** the .ics file into your preferred calendar app

## Development

### Processing New Exam Data

If you have new exam data in Excel format:

```bash
python3 process_excel.py SpringFinalExams2025.xlsx
```

This will update the exam data in the application.

### Adding New Exam Times

To add new exam times manually, edit the `examTimes` object in `index.html`:

```javascript
const examTimes = {
  "8:30 mwf": "WED 10:00 AM–12:00 PM",
  "your new class": "DAY TIME–TIME",
  // ... add more mappings
};
```

## Project Structure

```
ExamSchedule/
├── index.html              # Main application (HTML + CSS + JavaScript)
├── process_excel.py        # Python script to process Excel data
├── SpringFinalExams2025.xlsx # Original Excel data
├── exams.json              # Processed exam data
├── db/                     # Database files (if needed)
└── README.md              # This file
```

## Deployment

Since this is a static HTML application, you can deploy it to any static hosting service:

- **GitHub Pages**: Enable in repository settings
- **Netlify**: Drag and drop the files
- **Vercel**: Connect your GitHub repository
- **Any web server**: Just serve the files

## License

MIT License - see [LICENSE](LICENSE) file for details.
