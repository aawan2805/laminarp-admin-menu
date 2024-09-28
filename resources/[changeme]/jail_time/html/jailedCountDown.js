window.addEventListener('message', (event) => {
    let data = event.data;

    if (data.action === 'openJailCountdown') {
        alert(`Jail countdown started! Time left: ${data.timeLeft}`);
        // Here you would display the countdown in your HTML instead of an alert
        document.getElementById('countdownDisplay').innerText = `Time left: ${data.timeLeft} seconds`;
        // Make sure to show the UI if it’s hidden
        document.getElementById('countdownUI').style.display = 'block';
    }

    if (data.action === 'updateCountdown') {
        // Update the countdown display
        document.getElementById('countdownDisplay').innerText = `Time left: ${data.timeLeft} seconds`;
    }
});
