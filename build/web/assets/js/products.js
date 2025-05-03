document.addEventListener('DOMContentLoaded', function() {
    // Sample product data with more items
    const products = [
        {
            id: 1,
            name: "MacBook Air M1",
            price: 75999,
            originalPrice: 89999,
            category: "electronics",
            image: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1633027804000",
            condition: "New",
            location: "Block A",
            isNew: true
        },
        {
            id: 2,
            name: "iPhone 13",
            price: 59999,
            originalPrice: 69999,
            category: "electronics",
            image: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-blue-select-2021?wid=940&hei=1112&fmt=png-alpha&.v=1645572386470",
            condition: "Like New",
            location: "Block B",
            isNew: false
        },
        {
            id: 3,
            name: "Calculus Textbook",
            price: 450,
            originalPrice: 599,
            category: "books",
            image: "https://m.media-amazon.com/images/I/71eBB8wX4KL._AC_UF1000,1000_QL80_.jpg",
            condition: "Good",
            location: "Block C",
            isNew: false
        },
        {
            id: 4,
            name: "Wireless Earbuds",
            price: 2499,
            originalPrice: 3499,
            category: "electronics",
            image: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1660803972361",
            condition: "New",
            location: "Block A",
            isNew: true
        },
        {
            id: 5,
            name: "Campus Backpack",
            price: 1299,
            originalPrice: 1799,
            category: "accessories",
            image: "https://m.media-amazon.com/images/I/71YEY+JRlYL._AC_UF1000,1000_QL80_.jpg",
            condition: "New",
            location: "Block D",
            isNew: true
        },
        {
            id: 6,
            name: "Scientific Calculator",
            price: 899,
            originalPrice: 1199,
            category: "electronics",
            image: "https://m.media-amazon.com/images/I/71km+yZd5tL._AC_UF1000,1000_QL80_.jpg",
            condition: "Like New",
            location: "Block B",
            isNew: false
        },
        {
            id: 7,
            name: "Study Table",
            price: 3499,
            originalPrice: 4499,
            category: "furniture",
            image: "https://m.media-amazon.com/images/I/71Zf9uUp+GL._AC_UF1000,1000_QL80_.jpg",
            condition: "New",
            location: "Block E",
            isNew: true
        },
        {
            id: 8,
            name: "College Hoodie",
            price: 799,
            originalPrice: 999,
            category: "clothing",
            image: "https://m.media-amazon.com/images/I/61N0Rx7-IUL._AC_UY1000_.jpg",
            condition: "New",
            location: "Block F",
            isNew: true
        }
    ];

    const productsGrid = document.querySelector('.products-grid');
    const categoryCheckboxes = document.querySelectorAll('.filter-options input[type="checkbox"]');
    const searchInput = document.querySelector('.search-input');

    // Initialize the page
    renderProducts(products);
    setupEventListeners();

    function renderProducts(productsToRender) {
        productsGrid.innerHTML = '';
        
        productsToRender.forEach(product => {
            const discount = Math.round(((product.originalPrice - product.price) / product.originalPrice) * 100);
            
            const productCard = document.createElement('div');
            productCard.className = 'product-card';
            
            productCard.innerHTML = `
                <div class="product-image">
                    <img src="${product.image}" alt="${product.name}" onerror="this.src='assets/images/placeholder.jpg'">
                    <button class="wishlist-btn" aria-label="Add to wishlist">
                        <i class="far fa-heart"></i>
                    </button>
                </div>
                <div class="product-info">
                    <h3 class="product-title">
                        ${product.name} 
                        <span class="product-condition">(${product.condition}${product.isNew ? ' • New' : ''})</span>
                    </h3>
                    <div class="product-price">
                        <span class="current-price">₹${product.price.toLocaleString('en-IN')}</span>
                        <span class="original-price">₹${product.originalPrice.toLocaleString('en-IN')}</span>
                        <span class="discount">${discount}% off</span>
                    </div>
                    <div class="product-meta">
                        <span class="location"><i class="fas fa-map-marker-alt"></i> ${product.location}</span>
                    </div>
                    <button class="add-to-cart">Add to Cart</button>
                </div>`;
            
            productsGrid.appendChild(productCard);
        });

        // Update product count
        const productCount = document.querySelector('.products-count span');
        productCount.textContent = `(${productsToRender.length} items)`;
    }

    function setupEventListeners() {
        // Category filter
        categoryCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', filterProducts);
        });

        // Search filter
        searchInput.addEventListener('input', filterProducts);
    }

    function filterProducts() {
        const searchQuery = searchInput.value.toLowerCase();
        const selectedCategories = Array.from(document.querySelectorAll('.category-filter input:checked')).map(input => input.value);
        const minPrice = parseInt(document.querySelector('.range-values input[type="number"]:first-child').value);
        const maxPrice = parseInt(document.querySelector('.range-values input[type="number"]:last-child').value);

        const filteredProducts = products.filter(product => {
            const matchesSearch = product.name.toLowerCase().includes(searchQuery);
            const matchesCategory = selectedCategories.length === 0 || selectedCategories.includes(product.category);
            const matchesPrice = product.price >= minPrice && product.price <= maxPrice;
            return matchesSearch && matchesCategory && matchesPrice;
        });

        renderProducts(filteredProducts);
    }

    // Price Range Filter Functionality
    const minInput = document.querySelector('.range-values input[type="number"]:first-child');
    const maxInput = document.querySelector('.range-values input[type="number"]:last-child');
    const minSlider = document.querySelector('.range-inputs input[type="range"]:first-child');
    const maxSlider = document.querySelector('.range-inputs input[type="range"]:last-child');

    // Set initial values
    const minPrice = 0;
    const maxPrice = 100000;
    
    minSlider.value = minPrice;
    maxSlider.value = maxPrice;
    minInput.value = minPrice;
    maxInput.value = maxPrice;

    // Update range input values when number inputs change
    minInput.addEventListener('change', function() {
        let value = parseInt(this.value);
        if (value < minPrice) value = minPrice;
        if (value > parseInt(maxInput.value)) value = parseInt(maxInput.value);
        minSlider.value = value;
        this.value = value;
        updateRangeProgress();
        filterProducts();
    });

    maxInput.addEventListener('change', function() {
        let value = parseInt(this.value);
        if (value > maxPrice) value = maxPrice;
        if (value < parseInt(minInput.value)) value = parseInt(minInput.value);
        maxSlider.value = value;
        this.value = value;
        updateRangeProgress();
        filterProducts();
    });

    // Update number input values when range inputs change
    minSlider.addEventListener('input', function() {
        let value = parseInt(this.value);
        if (value > parseInt(maxSlider.value)) {
            value = parseInt(maxSlider.value);
            this.value = value;
        }
        minInput.value = value;
        updateRangeProgress();
        filterProducts();
    });

    maxSlider.addEventListener('input', function() {
        let value = parseInt(this.value);
        if (value < parseInt(minSlider.value)) {
            value = parseInt(minSlider.value);
            this.value = value;
        }
        maxInput.value = value;
        updateRangeProgress();
        filterProducts();
    });

    // Function to update the range progress bar
    function updateRangeProgress() {
        const percent1 = ((minSlider.value - minPrice) / (maxPrice - minPrice)) * 100;
        const percent2 = ((maxSlider.value - minPrice) / (maxPrice - minPrice)) * 100;
        
        document.querySelector('.range-inputs').style.background = 
            `linear-gradient(to right, 
                var(--border-color) ${percent1}%, 
                var(--primary-color) ${percent1}%, 
                var(--primary-color) ${percent2}%, 
                var(--border-color) ${percent2}%)`;
    }

    // Initial update of the range progress bar
    updateRangeProgress();

    // Product filtering and sorting functionality
    let productsGrid;
    let categoryFilter;
    let minPriceInput;
    let maxPriceInput;
    let availabilityFilter;
    let sortBy;

    // Function to apply all filters
    window.applyFilters = function() {
        if (!productsGrid) {
            productsGrid = document.getElementById('productsGrid');
        }
        if (!categoryFilter) {
            categoryFilter = document.getElementById('categoryFilter');
        }
        if (!minPriceInput) {
            minPriceInput = document.getElementById('minPrice');
        }
        if (!maxPriceInput) {
            maxPriceInput = document.getElementById('maxPrice');
        }
        if (!availabilityFilter) {
            availabilityFilter = document.getElementById('availabilityFilter');
        }
        if (!sortBy) {
            sortBy = document.getElementById('sortBy');
        }

        const selectedCategory = categoryFilter.value;
        const minPriceValue = parseFloat(minPriceInput.value) || 0;
        const maxPriceValue = parseFloat(maxPriceInput.value) || Infinity;
        const selectedAvailability = availabilityFilter.value;
        const sortOption = sortBy.value;
        
        // Filter products
        const filteredProducts = Array.from(document.querySelectorAll('.product-card')).filter(card => {
            const category = card.querySelector('.product-category').textContent;
            const price = parseFloat(card.querySelector('.product-price').textContent.replace('₹', ''));
            const availability = card.querySelector('.product-status').textContent.trim();
            
            const categoryMatch = !selectedCategory || category === selectedCategory;
            const priceMatch = price >= minPriceValue && price <= maxPriceValue;
            const availabilityMatch = !selectedAvailability || 
                (selectedAvailability === 'available' && availability === 'AVAILABLE') ||
                (selectedAvailability === 'sold' && availability === 'SOLD');
            
            return categoryMatch && priceMatch && availabilityMatch;
        });
        
        // Sort products
        const sortedProducts = sortProducts(filteredProducts, sortOption);
        
        // Clear and re-render products
        productsGrid.innerHTML = '';
        sortedProducts.forEach(card => {
            productsGrid.appendChild(card);
        });
    };

    // Function to sort products
    function sortProducts(products, sortOption) {
        return [...products].sort((a, b) => {
            const priceA = parseFloat(a.querySelector('.product-price').textContent.replace('₹', ''));
            const priceB = parseFloat(b.querySelector('.product-price').textContent.replace('₹', ''));
            const nameA = a.querySelector('.product-name').textContent;
            const nameB = b.querySelector('.product-name').textContent;
            
            switch(sortOption) {
                case 'price_asc':
                    return priceA - priceB;
                case 'price_desc':
                    return priceB - priceA;
                case 'name_asc':
                    return nameA.localeCompare(nameB);
                case 'name_desc':
                    return nameB.localeCompare(nameA);
                case 'newest':
                    // Assuming newer products have higher IDs
                    const idA = parseInt(a.dataset.productId);
                    const idB = parseInt(b.dataset.productId);
                    return idB - idA;
                default:
                    return 0;
            }
        });
    }

    // Function to reset all filters
    window.resetFilters = function() {
        if (!categoryFilter) {
            categoryFilter = document.getElementById('categoryFilter');
        }
        if (!minPriceInput) {
            minPriceInput = document.getElementById('minPrice');
        }
        if (!maxPriceInput) {
            maxPriceInput = document.getElementById('maxPrice');
        }
        if (!availabilityFilter) {
            availabilityFilter = document.getElementById('availabilityFilter');
        }
        if (!sortBy) {
            sortBy = document.getElementById('sortBy');
        }

        categoryFilter.value = '';
        minPriceInput.value = '';
        maxPriceInput.value = '';
        availabilityFilter.value = '';
        sortBy.value = 'default';
        applyFilters();
    };

    // Initialize event listeners when DOM is loaded
    document.addEventListener('DOMContentLoaded', function() {
        productsGrid = document.getElementById('productsGrid');
        categoryFilter = document.getElementById('categoryFilter');
        minPriceInput = document.getElementById('minPrice');
        maxPriceInput = document.getElementById('maxPrice');
        availabilityFilter = document.getElementById('availabilityFilter');
        sortBy = document.getElementById('sortBy');
        
        if (categoryFilter) categoryFilter.addEventListener('change', applyFilters);
        if (minPriceInput) minPriceInput.addEventListener('change', applyFilters);
        if (maxPriceInput) {
            maxPriceInput.addEventListener('change', applyFilters);
            maxPriceInput.addEventListener('input', applyFilters);
        }
        if (availabilityFilter) availabilityFilter.addEventListener('change', applyFilters);
        if (sortBy) sortBy.addEventListener('change', applyFilters);
    });
});