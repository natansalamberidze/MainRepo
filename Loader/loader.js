// Waiting for the page to load completely
window.addEventListener('load', function() {
    const el = document.querySelector(".number");
    
    if (!el) {
        console.warn("Element not found, cancel animation");
        return;
    }
    
    animateCounter(el);
});

function animateCounter(element) {
    const targetValue = Number(element.dataset.value) || 0;
    let counter = 0;
    
    const interval = setInterval(() => {
        if (counter < targetValue) {
            counter++;
            element.textContent = `${counter}%`;
        } else {
            clearInterval(interval);
        }
    }, 80);
}

document.addEventListener('DOMContentLoaded', function() {
    const el = document.querySelector(".number");
    const doneElement = document.querySelector(".progress-done");
    
    if (!el || !doneElement) return;
    
    const elValue = Number(el.getAttribute("data-value"));
    let counter = 0;

    const interval = setInterval(() => {
        if (counter < elValue) {
            counter++;
            el.innerHTML = `${counter}%`;
            
            // Change color when approaching 100%
            if (counter > 90) {
                el.style.color = '#4CAF50';
            }
        } else {
            clearInterval(interval);
            showDoneMessage();
        }
    }, 80);

    function showDoneMessage() {
        doneElement.classList.add('show');
        
        // Automatic hiding after 3 seconds
        setTimeout(() => {
            doneElement.classList.remove('show');
        }, 3000);
    }
});