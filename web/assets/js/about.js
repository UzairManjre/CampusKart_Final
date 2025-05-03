document.addEventListener('DOMContentLoaded', function() {
    // Add animation to value cards on scroll
    const valueCards = document.querySelectorAll('.value-card');
    const teamMembers = document.querySelectorAll('.team-member');
    
    // Intersection Observer for animations
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate');
            }
        });
    }, {
        threshold: 0.1
    });
    
    // Observe value cards and team members
    valueCards.forEach(card => observer.observe(card));
    teamMembers.forEach(member => observer.observe(member));
    
    // Add smooth scroll to sections
    const navLinks = document.querySelectorAll('a[href^="#"]');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                targetSection.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Add hover effect to team member images
    teamMembers.forEach(member => {
        const img = member.querySelector('img');
        if (img) {
            member.addEventListener('mouseenter', () => {
                img.style.transform = 'scale(1.05)';
            });
            
            member.addEventListener('mouseleave', () => {
                img.style.transform = 'scale(1)';
            });
        }
    });
}); 