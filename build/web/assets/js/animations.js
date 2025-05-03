// Register ScrollTrigger plugin
gsap.registerPlugin(ScrollTrigger);

// Use the header from common.js
const header = document.querySelector('.main-header');

// Add scroll animations
window.addEventListener('scroll', () => {
    if (header) {
        if (window.scrollY > 100) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    }
});

// Hero section animations
const heroElements = gsap.utils.toArray('[data-gsap="fade-up"]');
gsap.set(heroElements, { opacity: 0, y: 50 });

const heroTimeline = gsap.timeline({ defaults: { duration: 1, ease: 'power3.out' } });
heroTimeline
    .to('.hero-title', { opacity: 1, y: 0, duration: 1 })
    .to('.hero-subtitle', { opacity: 1, y: 0 }, '-=0.8')
    .to('.cta', { opacity: 1, y: 0 }, '-=0.8');

// Product cards stagger animation
const productCards = gsap.utils.toArray('.product-card');
productCards.forEach((card) => {
    gsap.set(card, { opacity: 0, y: 50 });
    
    ScrollTrigger.create({
        trigger: card,
        start: 'top bottom-=100',
        onEnter: () => {
            gsap.to(card, {
                opacity: 1,
                y: 0,
                duration: 0.8,
                ease: 'power3.out'
            });
        }
    });
});

// Product card hover effect
productCards.forEach((card) => {
    card.addEventListener('mouseenter', () => {
        gsap.to(card, {
            scale: 1.03,
            duration: 0.3,
            ease: 'power2.out',
            boxShadow: '0 10px 20px rgba(0,0,0,0.1)'
        });
    });

    card.addEventListener('mouseleave', () => {
        gsap.to(card, {
            scale: 1,
            duration: 0.3,
            ease: 'power2.out',
            boxShadow: 'var(--shadow-sm)'
        });
    });
});

// Smooth scroll to sections
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            gsap.to(window, {
                duration: 1,
                scrollTo: {
                    y: target,
                    offsetY: 80
                },
                ease: 'power3.inOut'
            });
        }
    });
});

// Smooth scroll animation for CTA button
document.addEventListener('DOMContentLoaded', () => {
    const ctaButton = document.querySelector('.cta[data-scroll-to]');
    
    if (ctaButton) {
        ctaButton.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = ctaButton.getAttribute('data-scroll-to');
            const targetSection = document.getElementById(targetId);
            
            if (targetSection) {
                // Create a timeline for the scroll animation
                const scrollTimeline = gsap.timeline();
                
                // Add button click animation
                scrollTimeline.to(ctaButton, {
                    scale: 0.95,
                    duration: 0.1,
                    ease: 'power2.in',
                    yoyo: true,
                    repeat: 1
                });
                
                // Add smooth scroll animation
                scrollTimeline.to(window, {
                    duration: 1.2,
                    scrollTo: {
                        y: targetSection,
                        offsetY: 80, // Offset for header height
                        autoKill: false
                    },
                    ease: 'power2.inOut'
                });
                
                // Add reveal animation for the products section
                scrollTimeline.from(targetSection, {
                    opacity: 0,
                    y: 50,
                    duration: 0.8,
                    ease: 'power2.out'
                }, '-=0.4');
                
                // Add stagger animation for product cards
                scrollTimeline.from('.product-card', {
                    opacity: 0,
                    y: 30,
                    duration: 0.6,
                    stagger: 0.1,
                    ease: 'power2.out'
                }, '-=0.4');
            }
        });
    }
});

// Add fade-in animations for product cards
document.addEventListener('DOMContentLoaded', () => {
    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        setTimeout(() => {
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
}); 