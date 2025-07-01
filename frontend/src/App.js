import React, { useState } from 'react';

function icsDate(date, time) {
  // Example: date = "2025-05-28", time = "10:00 AM"
  let [year, month, day] = date.split('-');
  let [hm, ampm] = time.split(' ');
  let [hour, min] = hm.split(':').map(Number);
  if (ampm === "PM" && hour < 12) hour += 12;
  if (ampm === "AM" && hour === 12) hour = 0;
  return `${year}${month}${day}T${hour.toString().padStart(2,'0')}${min.toString().padStart(2,'0')}00`;
}

function parseExamTime(examStr) {
  // e.g. "WED 10:00 AM–12:00 PM"
  const dayToDate = { TU: "2025-05-27", WED: "2025-05-28", TH: "2025-05-29", FRI: "2025-05-30" };
  let [day, times] = examStr.split(' ');
  let [start, end] = times.split(/[–-]/);
  let date = dayToDate[day];
  return { date, start: start.trim(), end: end.trim() };
}

export default function App() {
  const [classTime, setClassTime] = useState('');
  const [label, setLabel] = useState('');
  const [cart, setCart] = useState([]);
  const [examTime, setExamTime] = useState('');
  const [error, setError] = useState('');

  async function lookupExamTime() {
    setError('');
    setExamTime('');
    const resp = await fetch(`/api/exam-time?classTime=${encodeURIComponent(classTime)}`);
    const data = await resp.json();
    if (data.examTime) setExamTime(data.examTime);
    else setError('No exam time found.');
  }

  function addToCart() {
    if (!label || !examTime) return;
    setCart([...cart, { label, classTime, examTime }]);
    setLabel('');
    setClassTime('');
    setExamTime('');
  }

  function exportICS() {
    let ics = [
      "BEGIN:VCALENDAR",
      "VERSION:2.0",
      "CALSCALE:GREGORIAN"
    ];
    cart.forEach(item => {
      const exam = parseExamTime(item.examTime);
      if (!exam || !exam.date) return;
      let dtstart = icsDate(exam.date, exam.start);
      let dtend = icsDate(exam.date, exam.end);
      ics.push("BEGIN:VEVENT");
      ics.push(`SUMMARY:${item.label} Final Exam`);
      ics.push(`DESCRIPTION:Class Time: ${item.classTime}`);
      ics.push(`DTSTART;TZID=America/Chicago:${dtstart}`);
      ics.push(`DTEND;TZID=America/Chicago:${dtend}`);
      ics.push("END:VEVENT");
    });
    ics.push("END:VCALENDAR");
    let blob = new Blob([ics.join('\r\n')], {type: "text/calendar"});
    let link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = "UChicagoFinalExams.ics";
    document.body.appendChild(link);
    link.click();
    setTimeout(() => { document.body.removeChild(link); }, 100);
  }

  return (
    <div style={{maxWidth: 500, margin: "2em auto", background: "#fff", borderRadius: 8, padding: "2em", boxShadow: "0 2px 8px #0001"}}>
      <h1>UChicago Exam Scheduler MVP</h1>
      <input value={classTime} onChange={e => setClassTime(e.target.value)} placeholder="e.g. 8:30 MWF or CMSC 23200" />
      <button onClick={lookupExamTime}>Lookup</button>
      {examTime && <div style={{marginTop: 10}}>Final Exam: <b>{examTime}</b></div>}
      {error && <div style={{color: "red"}}>{error}</div>}
      <input value={label} onChange={e => setLabel(e.target.value)} placeholder="Label for your calendar" />
      <button onClick={addToCart} disabled={!examTime || !label}>Add to Cart</button>
      <h3>Your Classes Cart</h3>
      <ul>
        {cart.map((item, i) =>
          <li key={i}><b>{item.label}</b> ({item.classTime} → {item.examTime})</li>
        )}
      </ul>
      {cart.length > 0 && <button onClick={exportICS}>Export to Calendar (.ics)</button>}
    </div>
  );
}
