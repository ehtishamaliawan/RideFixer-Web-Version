document.addEventListener('DOMContentLoaded', () => {
    
    // --- Intersection Observer for Scroll Animations ---
    // Adds a premium "fade in up" effect as users scroll down the landing page
    
    // Add base CSS for the animation dynamically
    const style = document.createElement('style');
    style.innerHTML = `
        .fade-in-section {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease-out, transform 0.6s ease-out;
            will-change: opacity, visibility;
        }
        .fade-in-section.is-visible {
            opacity: 1;
            transform: none;
        }
    `;
    document.head.appendChild(style);

    // Select elements to animate
    const sections = document.querySelectorAll('.card, .feature-card, .graph-visualizer');
    
    sections.forEach(section => {
        section.classList.add('fade-in-section');
    });

    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.15 // Triggers when 15% of the element is visible
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-visible');
                // Unobserve after animating once to improve performance
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    sections.forEach(section => {
        observer.observe(section);
    });

    // --- Interactive CTA Bindings (MVP Placeholders) ---
    
    const demoBtns = document.querySelectorAll('.demo-btn');
    const loginBtns = document.querySelectorAll('.login-btn');

    demoBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            // In production, this would open a Calendly modal or lead form
            alert('Opening Demo Scheduler for Fleet Managers. \n\n(MVP Feature: Integration pending)');
        });
    });

    loginBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            // In production, this routes to the Auth/GraphRAG dashboard
            alert('Redirecting to secure Mechanic SSO Portal. \n\n(MVP Feature: Integration pending)');
        });
    });
});