document.addEventListener('DOMContentLoaded', function() {
    const faqItems = document.querySelectorAll('.faq-item');
    const categoryButtons = document.querySelectorAll('.category-btn');
    const searchInput = document.getElementById('faqSearch');
    const faqCategories = document.querySelectorAll('.faq-category');
    
    // Toggle FAQ items
    faqItems.forEach(item => {
        const question = item.querySelector('.faq-question');
        question.addEventListener('click', () => {
            // Close all other items
            faqItems.forEach(otherItem => {
                if (otherItem !== item) {
                    otherItem.classList.remove('active');
                }
            });
            
            // Toggle current item
            item.classList.toggle('active');
        });
    });
    
    // Category filtering
    categoryButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Update active button
            categoryButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
            
            const category = button.dataset.category;
            
            // Show/hide categories based on selection
            faqCategories.forEach(cat => {
                if (category === 'all' || cat.dataset.category === category) {
                    cat.style.display = 'block';
                } else {
                    cat.style.display = 'none';
                }
            });
        });
    });
    
    // Search functionality
    searchInput.addEventListener('input', () => {
        const searchTerm = searchInput.value.toLowerCase();
        
        faqItems.forEach(item => {
            const question = item.querySelector('.faq-question h3').textContent.toLowerCase();
            const answer = item.querySelector('.faq-answer p').textContent.toLowerCase();
            
            if (question.includes(searchTerm) || answer.includes(searchTerm)) {
                item.style.display = 'block';
                
                // Show parent category
                const category = item.closest('.faq-category');
                if (category) {
                    category.style.display = 'block';
                }
            } else {
                item.style.display = 'none';
            }
            
            // Check if category has any visible items
            faqCategories.forEach(category => {
                const visibleItems = category.querySelectorAll('.faq-item[style="display: block"]');
                if (visibleItems.length === 0) {
                    category.style.display = 'none';
                }
            });
        });
    });
    
    // Reset search when changing categories
    categoryButtons.forEach(button => {
        button.addEventListener('click', () => {
            searchInput.value = '';
            faqItems.forEach(item => {
                item.style.display = 'block';
            });
        });
    });
    
    // Add smooth scroll to FAQ items
    const hash = window.location.hash;
    if (hash) {
        const targetItem = document.querySelector(hash);
        if (targetItem) {
            targetItem.classList.add('active');
            targetItem.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }
}); 