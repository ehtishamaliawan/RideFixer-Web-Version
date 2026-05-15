(function () {
  const panel = document.getElementById('batteryPanel');
  if (!panel) return;

  const questions = [
    { key: 'age', label: 'Battery age', options: ['Less than 6 months', '6 months to 1 year', '1 to 2 years', '2 to 3 years', '3 to 4 years', 'More than 4 years'] },
    { key: 'cycles', label: 'Charge cycle habit', options: ['Every day', 'Every 2-3 days', 'Once a week', 'Only when completely empty', 'Irregularly'] },
    { key: 'rangeLoss', label: 'Range loss', options: ['Same as new - no change', 'Slightly less - about 10-20% reduction', 'Noticeably less - about 20-40% reduction', 'Significantly less - about 40-60% reduction', 'Much worse - over 60% reduction'] },
    { key: 'charging', label: 'Charging habit', options: ['Always charge to 100%', 'Charge to 80-90% mostly', 'Leave on charger overnight regularly', 'Charge from completely empty always', 'Mix of different habits'] },
    { key: 'storage', label: 'Storage habit', options: ['Always on the bike outside', 'Indoors at room temperature', 'In garage - can get very cold or hot', 'Remove and store indoors in winter', "Don't know"] },
    { key: 'voltage', label: 'Battery voltage', options: ['36V', '48V', '52V', '72V', "Don't know"] },
  ];

  let step = 0;
  const answers = {};

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/\"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function clamp(value, min, max) {
    return Math.max(min, Math.min(max, value));
  }

  function calculate() {
    let score = 0;
    let confidence = 100;

    if (answers.age === 'Less than 6 months') score += 20;
    else if (answers.age === '6 months to 1 year') score += 18;
    else if (answers.age === '1 to 2 years') score += 15;
    else if (answers.age === '2 to 3 years') score += 10;
    else if (answers.age === '3 to 4 years') score += 6;
    else score += 2;

    if (answers.cycles === 'Every 2-3 days') score += 15;
    else if (answers.cycles === 'Once a week') score += 12;
    else if (answers.cycles === 'Irregularly') score += 9;
    else if (answers.cycles === 'Every day') score += 8;
    else score += 4;

    if (answers.rangeLoss === 'Same as new - no change') score += 25;
    else if (answers.rangeLoss.indexOf('10-20') !== -1) score += 20;
    else if (answers.rangeLoss.indexOf('20-40') !== -1) score += 14;
    else if (answers.rangeLoss.indexOf('40-60') !== -1) score += 7;
    else score += 2;

    if (answers.charging === 'Charge to 80-90% mostly') score += 20;
    else if (answers.charging === 'Always charge to 100%') score += 12;
    else if (answers.charging === 'Mix of different habits') score += 11;
    else if (answers.charging === 'Charge from completely empty always') score += 5;
    else score += 4;

    if (answers.storage === 'Indoors at room temperature') score += 15;
    else if (answers.storage === 'Remove and store indoors in winter') score += 14;
    else if (answers.storage === "Don't know") {
      score += 9;
      confidence -= 8;
    } else if (answers.storage.indexOf('garage') !== -1) score += 7;
    else score += 3;

    if (answers.voltage === "Don't know") confidence -= 12;

    const severe = answers.rangeLoss.indexOf('40-60') !== -1 || answers.rangeLoss.indexOf('over 60') !== -1;
    const old = answers.age === '3 to 4 years' || answers.age === 'More than 4 years';
    if (severe) score = Math.min(score, 49);
    if (severe && old) score = Math.min(score, 29);

    score = clamp(score, 0, 100);
    confidence = clamp(confidence, 60, 100);

    const status = score >= 80 ? 'Excellent' : score >= 60 ? 'Good' : score >= 40 ? 'Weak' : 'Critical';
    return { score: score, confidence: confidence, status: status };
  }

  function render() {
    const question = questions[step];
    if (step < questions.length) {
      panel.innerHTML = `
        <h3 style="margin:0 0 8px;">Step ${step + 1} of ${questions.length}</h3>
        <p class="sub" style="margin:0 0 10px;">${escapeHtml(question.label)}</p>
        <form id="batteryForm" style="display:grid;gap:8px;">
          <select id="batteryAnswer" required>
            <option value="">Choose...</option>
            ${question.options.map((opt) => `<option value="${escapeHtml(opt)}">${escapeHtml(opt)}</option>`).join('')}
          </select>
          <div style="display:flex;gap:8px;flex-wrap:wrap;">
            <button class="btn btn-brand" type="submit">${step === questions.length - 1 ? 'Calculate' : 'Next'}</button>
            <button class="btn btn-ghost" type="button" id="backBtn" ${step === 0 ? 'disabled' : ''}>Back</button>
          </div>
        </form>
      `;

      document.getElementById('batteryForm').addEventListener('submit', (event) => {
        event.preventDefault();
        const value = document.getElementById('batteryAnswer').value;
        if (!value) return;
        answers[question.key] = value;
        step += 1;
        render();
      });

      const backBtn = document.getElementById('backBtn');
      if (backBtn) {
        backBtn.addEventListener('click', () => {
          if (step > 0) step -= 1;
          render();
        });
      }
      return;
    }

    const result = calculate();
    panel.innerHTML = `
      <h3 style="margin:0 0 10px;">Battery score: ${result.score}/100</h3>
      <p class="sub">Status: <strong>${result.status}</strong> | Confidence: <strong>${result.confidence}%</strong></p>
      <div style="margin-top:10px;"><button id="restartBattery" class="btn btn-brand" type="button">Run Again</button></div>
    `;
    document.getElementById('restartBattery').addEventListener('click', () => {
      step = 0;
      Object.keys(answers).forEach((key) => delete answers[key]);
      render();
    });
  }

  render();
})();
