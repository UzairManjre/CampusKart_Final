<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="components/header.jsp" %>
<%
if (user == null) {
    response.sendRedirect("login.html");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sell Product - Campus Kart</title>
    
    <!-- Common/Header CSS for consistent header styling -->
    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/style.css">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- GSAP -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="assets/js/common.js"></script>
    
    <style>
        /* Base Styles */
        :root {
            --primary: #6c63ff;
            --primary-light: #8f88ff;
            --primary-dark: #5a52d5;
            --background: #f8f9fa;
            --text-dark: #2d3436;
            --text-light: #636e72;
            --border-color: rgba(108, 99, 255, 0.2);
            --shadow-sm: 0 4px 6px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 8px 15px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 15px 30px rgba(0, 0, 0, 0.15);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 20px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--background);
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(108, 99, 255, 0.05) 0%, transparent 20%),
                radial-gradient(circle at 90% 80%, rgba(108, 99, 255, 0.05) 0%, transparent 20%);
            background-attachment: fixed;
        }

        /* Page Layout */
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: fadeIn 0.8s ease-out;
        }

        .page-title {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .page-subtitle {
            font-size: 1.1rem;
            color: var(--text-light);
            max-width: 600px;
            margin: 0 auto;
        }

        /* Navigation */
        .nav-back {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 2rem;
            transition: transform 0.3s ease;
        }

        .nav-back:hover {
            transform: translateX(-5px);
        }

        .nav-back i {
            font-size: 1.2rem;
        }

        /* Form Styles */
        .sell-product-card {
            background: rgba(255, 255, 255, 0.85);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-lg);
            backdrop-filter: blur(10px);
            border: 1px solid var(--border-color);
            overflow: hidden;
            transform: translateY(0);
            transition: var(--transition);
        }

        .sell-product-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg), 0 20px 40px rgba(108, 99, 255, 0.1);
        }

        .form-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: white;
            padding: 3rem 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transform: translateX(-100%);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            100% { transform: translateX(100%); }
        }

        .form-content {
            padding: 2.5rem;
            display: grid;
            gap: 2rem;
        }

        .form-group {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary);
            font-size: 1.2rem;
            transition: var(--transition);
            z-index: 1;
        }

        .form-textarea + .input-icon {
            top: 1.5rem;
            transform: none;
        }

        .form-input {
            width: 100%;
            padding: 1.2rem 1rem 1.2rem 3rem;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-md);
            font-size: 1rem;
            transition: var(--transition);
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(5px);
        }

        .form-textarea {
            padding-top: 1.5rem;
            min-height: 150px;
            resize: vertical;
        }

        .form-input:focus,
        .form-input:not(:placeholder-shown) {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 4px rgba(108, 99, 255, 0.1);
        }

        .form-input:focus + .input-icon,
        .form-input:not(:placeholder-shown) + .input-icon {
            color: var(--primary-dark);
            transform: scale(1.1) translateY(-50%);
        }

        .form-label {
            position: absolute;
            left: 3rem;
            top: 1rem;
            color: var(--text-light);
            transition: var(--transition);
            pointer-events: none;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.9);
            padding: 0 0.5rem;
        }

        .form-input:focus + .form-label,
        .form-input:not(:placeholder-shown) + .form-label {
            top: -0.5rem;
            left: 1rem;
            font-size: 0.875rem;
            color: var(--primary);
            background: rgba(255, 255, 255, 0.9);
        }

        /* Image Upload Styles */
        .image-upload-container {
            border: 2px dashed var(--border-color);
            border-radius: var(--radius-md);
            padding: 2rem;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(5px);
            transition: var(--transition);
        }

        .upload-area {
            text-align: center;
            padding: 2rem;
            cursor: pointer;
            transition: var(--transition);
            border-radius: var(--radius-sm);
        }

        .upload-area.drag-over {
            background: rgba(108, 99, 255, 0.05);
            border-color: var(--primary);
        }

        .image-upload-icon {
            font-size: 3rem;
            color: var(--primary);
            margin-bottom: 1rem;
            transition: var(--transition);
        }

        .upload-text {
            font-size: 1.1rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .upload-subtext {
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .preview-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .preview-item {
            position: relative;
            aspect-ratio: 1;
            border-radius: var(--radius-sm);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }

        .preview-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .remove-image {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: rgba(255, 255, 255, 0.9);
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: var(--text-dark);
            font-size: 0.8rem;
            transition: var(--transition);
        }

        .remove-image:hover {
            background: #ff4757;
            color: white;
        }

        /* Button Styles */
        .submit-button {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: white;
            border: none;
            padding: 1.2rem 2.5rem;
            border-radius: var(--radius-md);
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            width: 100%;
            position: relative;
            overflow: hidden;
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .submit-button:active {
            transform: translateY(0);
        }

        .submit-button::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s ease;
        }

        .submit-button:hover::after {
            transform: translateX(100%);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-container {
                padding: 1rem;
            }

            .form-header {
                padding: 2rem 1.5rem;
            }

            .form-content {
                padding: 1.5rem;
            }

            .page-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="page-container">
        <a href="index.jsp" class="nav-back">
            <i class="fas fa-arrow-left"></i>
            Back to Home
        </a>

        <div class="page-header">
            <h1 class="page-title">Sell Your Product</h1>
            <p class="page-subtitle">List your items for sale and reach potential buyers in your campus community.</p>
        </div>

        <form action="AddProductServlet" method="POST" enctype="multipart/form-data" class="sell-product-card">
            <% if (request.getParameter("success") != null) { %>
                <div style="background:#d4edda;color:#155724;border:1px solid #c3e6cb;padding:1rem;border-radius:8px;margin-bottom:1rem;">Product listed successfully!</div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div style="background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;padding:1rem;border-radius:8px;margin-bottom:1rem;">Error listing product. Please try again.</div>
            <% } %>
            <div class="form-header">
                <h2>Product Details</h2>
            </div>

            <div class="form-content">
                <div class="form-group">
                    <i class="fas fa-tag input-icon"></i>
                    <input type="text" id="productName" name="productName" class="form-input" placeholder=" " required>
                    <label for="productName" class="form-label">Product Name</label>
                </div>

                <div class="form-group">
                    <i class="fas fa-rupee-sign input-icon"></i>
                    <input type="number" id="price" name="price" class="form-input" placeholder=" " required min="0" step="0.01">
                    <label for="price" class="form-label">Price (₹)</label>
                </div>

                <div class="form-group">
                    <i class="fas fa-sort-numeric-up input-icon"></i>
                    <input type="number" id="quantity" name="quantity" class="form-input" placeholder=" " required min="1" step="1">
                    <label for="quantity" class="form-label">Quantity</label>
                </div>

                <div class="form-group">
                    <i class="fas fa-list input-icon"></i>
                    <select id="category" name="category" class="form-input" required>
                        <option value="">Select Category</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Books">Books</option>
                        <option value="Clothing">Clothing</option>
                        <option value="Sports">Sports</option>
                        <option value="Fashion">Fashion</option>
                        <option value="Home">Home</option>
                        <option value="Toys">Toys</option>
                        <option value="Others">Others</option>
                    </select>
                </div>

                <div class="form-group">
                    <i class="fas fa-align-left input-icon"></i>
                    <textarea id="description" name="description" class="form-input form-textarea" placeholder=" " required></textarea>
                    <label for="description" class="form-label">Product Description</label>
                </div>

                <div class="image-upload-container">
                    <div class="upload-area" id="uploadArea">
                        <i class="fas fa-cloud-upload-alt image-upload-icon"></i>
                        <p class="upload-text">Drag & Drop Images Here</p>
                        <p class="upload-subtext">or click to browse files</p>
                        <input type="file" id="productImages" name="productImages" multiple accept="image/*" style="display: none;">
                    </div>
                    <div class="preview-container" id="previewContainer"></div>
                </div>

                <button type="submit" class="submit-button">
                    List Product
                </button>
                <button type="button" class="submit-button" style="background:#fff;color:#6c63ff;border:1px solid #6c63ff;margin-top:1rem;" onclick="clearSellForm()">Clear Form</button>
            </div>
        </form>
    </div>

    <script>
        // Image Upload Handling
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('productImages');
        const previewContainer = document.getElementById('previewContainer');

        // Drag and drop handlers
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            uploadArea.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        ['dragenter', 'dragover'].forEach(eventName => {
            uploadArea.addEventListener(eventName, highlight, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            uploadArea.addEventListener(eventName, unhighlight, false);
        });

        function highlight(e) {
            uploadArea.classList.add('drag-over');
        }

        function unhighlight(e) {
            uploadArea.classList.remove('drag-over');
        }

        uploadArea.addEventListener('drop', handleDrop, false);
        uploadArea.addEventListener('click', () => fileInput.click());
        fileInput.addEventListener('change', handleFiles);

        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            handleFiles({ target: { files: files } });
        }

        function handleFiles(e) {
            const files = [...e.target.files];
            files.forEach(previewFile);
        }

        function previewFile(file) {
            if (!file.type.startsWith('image/')) return;

            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onloadend = function() {
                const previewItem = document.createElement('div');
                previewItem.className = 'preview-item';
                previewItem.innerHTML = `
                    <img src="${reader.result}" class="preview-image" alt="Preview">
                    <button type="button" class="remove-image" onclick="this.parentElement.remove()">
                        <i class="fas fa-times"></i>
                    </button>
                `;
                previewContainer.appendChild(previewItem);
            }
        }

        // Form Animation
        gsap.from('.sell-product-card', {
            duration: 1,
            y: 50,
            opacity: 0,
            ease: 'power3.out'
        });

        // Form Validation
        const form = document.querySelector('form');
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Basic validation
            const productName = document.getElementById('productName').value.trim();
            const price = document.getElementById('price').value;
            const category = document.getElementById('category').value;
            const description = document.getElementById('description').value.trim();
            const images = document.getElementById('productImages').files;

            if (!productName || !price || !category || !description) {
                alert('Please fill in all required fields');
                return;
            }

            if (images.length === 0) {
                alert('Please upload at least one product image');
                return;
            }

            // If validation passes, submit the form
            this.submit();
        });

        function clearSellForm() {
            document.getElementById('productName').value = '';
            document.getElementById('price').value = '';
            document.getElementById('quantity').value = '';
            document.getElementById('category').selectedIndex = 0;
            document.getElementById('description').value = '';
            document.getElementById('productImages').value = '';
            document.getElementById('previewContainer').innerHTML = '';
        }
    </script>
</body>
</html> 