document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for table of contents links
    const tocLinks = document.querySelectorAll('.toc-list a');
    
    tocLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetSection = document.getElementById(targetId);
            
            if (targetSection) {
                window.scrollTo({
                    top: targetSection.offsetTop - 100,
                    behavior: 'smooth'
                });
                
                // Add active class to the clicked link
                tocLinks.forEach(l => l.classList.remove('active'));
                this.classList.add('active');
            }
        });
    });

    // Highlight current section in table of contents while scrolling
    const sections = document.querySelectorAll('.terms-section');
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.5
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.getAttribute('id');
                tocLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === `#${id}`) {
                        link.classList.add('active');
                    }
                });
            }
        });
    }, observerOptions);

    sections.forEach(section => observer.observe(section));

    // Add "Last Updated" date
    const lastUpdatedElement = document.querySelector('.last-updated');
    if (lastUpdatedElement) {
        const lastUpdated = new Date();
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        lastUpdatedElement.textContent = lastUpdated.toLocaleDateString('en-US', options);
    }

    // Print functionality
    const printButton = document.querySelector('.print-button');
    if (printButton) {
        printButton.addEventListener('click', () => {
            window.print();
        });
    }

    // Add print-specific styles
    const style = document.createElement('style');
    style.textContent = `
        @media print {
            .header-container,
            .footer-container,
            .terms-breadcrumb,
            .print-button {
                display: none;
            }
            
            .terms-container {
                padding: 0;
                max-width: 100%;
            }
            
            .terms-hero {
                background: none;
                color: #000;
                padding: 1rem 0;
            }
            
            .toc-section {
                page-break-after: always;
            }
            
            .terms-section {
                page-break-inside: avoid;
            }
            
            a {
                text-decoration: none;
                color: #000;
            }
            
            a::after {
                content: " (" attr(href) ")";
                font-size: 0.8em;
            }
        }
    `;
    document.head.appendChild(style);
}); 