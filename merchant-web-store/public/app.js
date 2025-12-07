// Configuration
const API_BASE_URL = 'https://misty-mode-b68b.baharista1.workers.dev';
const STORE_ID = new URLSearchParams(window.location.search).get('store_id') || 'default';

// State
let store = null;
let categories = [];
let products = [];
let cart = JSON.parse(localStorage.getItem('cart') || '[]');

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadStore();
    loadCategories();
    loadProducts();
    updateCartUI();
    setupEventListeners();
});

// Event Listeners
function setupEventListeners() {
    document.getElementById('cartBtn').addEventListener('click', () => {
        document.getElementById('cartModal').classList.add('active');
        renderCart();
    });

    document.getElementById('closeCart').addEventListener('click', () => {
        document.getElementById('cartModal').classList.remove('active');
    });

    document.getElementById('checkoutBtn').addEventListener('click', () => {
        alert('سيتم إضافة عملية الدفع قريباً');
    });

    // Close modal on outside click
    document.getElementById('cartModal').addEventListener('click', (e) => {
        if (e.target.id === 'cartModal') {
            document.getElementById('cartModal').classList.remove('active');
        }
    });
}

// Load Store Info
async function loadStore() {
    try {
        const response = await fetch(`${API_BASE_URL}/public/stores/${STORE_ID}`);
        const data = await response.json();
        
        if (data.ok && data.data) {
            store = data.data;
            renderStoreInfo();
        }
    } catch (error) {
        console.error('Error loading store:', error);
    }
}

function renderStoreInfo() {
    if (!store) return;

    // Update hero section
    if (store.name) {
        document.getElementById('storeName').textContent = store.name;
    }
    if (store.description) {
        document.getElementById('storeDescription').textContent = store.description;
    }

    // Update about section
    const aboutContent = document.getElementById('aboutContent');
    aboutContent.innerHTML = `
        <h3>${store.name || 'متجرنا'}</h3>
        <p>${store.description || 'متجر إلكتروني متخصص في تقديم أفضل المنتجات'}</p>
        ${store.city ? `<p><strong>المدينة:</strong> ${store.city}</p>` : ''}
        ${store.phone ? `<p><strong>الهاتف:</strong> ${store.phone}</p>` : ''}
        ${store.email ? `<p><strong>البريد:</strong> ${store.email}</p>` : ''}
    `;

    // Update contact section
    const contactContent = document.getElementById('contactContent');
    contactContent.innerHTML = `
        ${store.phone ? `<p><strong>الهاتف:</strong> ${store.phone}</p>` : ''}
        ${store.email ? `<p><strong>البريد الإلكتروني:</strong> ${store.email}</p>` : ''}
        ${store.address ? `<p><strong>العنوان:</strong> ${store.address}</p>` : ''}
    `;
}

// Load Categories
async function loadCategories() {
    try {
        const response = await fetch(`${API_BASE_URL}/public/categories?store_id=${STORE_ID}`);
        const data = await response.json();
        
        if (data.ok && data.data) {
            categories = Array.isArray(data.data) ? data.data : data.data.categories || [];
            renderCategories();
            renderFilterButtons();
        }
    } catch (error) {
        console.error('Error loading categories:', error);
    }
}

function renderCategories() {
    const grid = document.getElementById('categoriesGrid');
    grid.innerHTML = '';

    if (categories.length === 0) {
        grid.innerHTML = '<p style="text-align: center; grid-column: 1/-1;">لا توجد فئات متاحة</p>';
        return;
    }

    categories.forEach(category => {
        const card = document.createElement('a');
        card.href = '#';
        card.className = 'category-card';
        card.dataset.categoryId = category.id;
        card.innerHTML = `
            <div class="category-icon">${category.icon || '📦'}</div>
            <div class="category-name">${category.name || 'فئة'}</div>
        `;
        card.addEventListener('click', (e) => {
            e.preventDefault();
            filterProducts(category.id);
        });
        grid.appendChild(card);
    });
}

function renderFilterButtons() {
    const container = document.getElementById('filterButtons');
    
    // Add "All" button
    const allBtn = document.createElement('button');
    allBtn.className = 'filter-btn active';
    allBtn.textContent = 'الكل';
    allBtn.dataset.category = 'all';
    allBtn.addEventListener('click', () => filterProducts('all'));
    container.appendChild(allBtn);

    // Add category buttons
    categories.forEach(category => {
        const btn = document.createElement('button');
        btn.className = 'filter-btn';
        btn.textContent = category.name;
        btn.dataset.category = category.id;
        btn.addEventListener('click', () => filterProducts(category.id));
        container.appendChild(btn);
    });
}

// Load Products
async function loadProducts() {
    const loading = document.getElementById('loading');
    loading.style.display = 'block';

    try {
        const response = await fetch(`${API_BASE_URL}/public/products?store_id=${STORE_ID}&status=active&limit=50`);
        const data = await response.json();
        
        if (data.ok && data.data) {
            products = Array.isArray(data.data) ? data.data : data.data.products || [];
            renderProducts(products);
        }
    } catch (error) {
        console.error('Error loading products:', error);
    } finally {
        loading.style.display = 'none';
    }
}

function renderProducts(productsToRender) {
    const grid = document.getElementById('productsGrid');
    grid.innerHTML = '';

    if (productsToRender.length === 0) {
        grid.innerHTML = '<p style="text-align: center; grid-column: 1/-1;">لا توجد منتجات متاحة</p>';
        return;
    }

    productsToRender.forEach(product => {
        const card = document.createElement('div');
        card.className = 'product-card';
        card.innerHTML = `
            <img src="${product.image_url || '/placeholder-product.jpg'}" 
                 alt="${product.name}" 
                 class="product-image"
                 onerror="this.src='https://via.placeholder.com/300x250?text=No+Image'">
            <div class="product-info">
                <div class="product-name">${product.name || 'منتج'}</div>
                <div class="product-price">${(product.price || 0).toFixed(2)} ر.س</div>
                <div class="product-actions">
                    <button class="btn-add-cart" onclick="addToCart('${product.id}', '${product.name}', ${product.price || 0}, '${product.image_url || ''}')">
                        أضف للسلة
                    </button>
                </div>
            </div>
        `;
        grid.appendChild(card);
    });
}

function filterProducts(categoryId) {
    // Update active filter button
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.category === categoryId) {
            btn.classList.add('active');
        }
    });

    // Filter products
    if (categoryId === 'all') {
        renderProducts(products);
    } else {
        const filtered = products.filter(p => p.category_id === categoryId);
        renderProducts(filtered);
    }
}

// Cart Functions
function addToCart(productId, productName, price, imageUrl) {
    const existingItem = cart.find(item => item.id === productId);
    
    if (existingItem) {
        existingItem.quantity += 1;
    } else {
        cart.push({
            id: productId,
            name: productName,
            price: price,
            image: imageUrl,
            quantity: 1
        });
    }

    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartUI();
    
    // Show notification
    showNotification('تم إضافة المنتج إلى السلة');
}

function removeFromCart(productId) {
    cart = cart.filter(item => item.id !== productId);
    localStorage.setItem('cart', JSON.stringify(cart));
    updateCartUI();
    renderCart();
}

function updateCartQuantity(productId, quantity) {
    const item = cart.find(item => item.id === productId);
    if (item) {
        item.quantity = Math.max(1, quantity);
        localStorage.setItem('cart', JSON.stringify(cart));
        updateCartUI();
        renderCart();
    }
}

function updateCartUI() {
    const count = cart.reduce((sum, item) => sum + item.quantity, 0);
    document.getElementById('cartCount').textContent = count;
}

function renderCart() {
    const container = document.getElementById('cartItems');
    const total = document.getElementById('cartTotal');
    
    if (cart.length === 0) {
        container.innerHTML = '<p style="text-align: center; padding: 2rem;">السلة فارغة</p>';
        total.textContent = '0';
        return;
    }

    container.innerHTML = cart.map(item => `
        <div class="cart-item" style="display: flex; gap: 1rem; padding: 1rem; border-bottom: 1px solid var(--border-color);">
            <img src="${item.image || 'https://via.placeholder.com/80'}" 
                 alt="${item.name}" 
                 style="width: 80px; height: 80px; object-fit: cover; border-radius: 8px;">
            <div style="flex: 1;">
                <h4>${item.name}</h4>
                <p>${item.price.toFixed(2)} ر.س</p>
                <div style="display: flex; gap: 0.5rem; align-items: center; margin-top: 0.5rem;">
                    <button onclick="updateCartQuantity('${item.id}', ${item.quantity - 1})">-</button>
                    <span>${item.quantity}</span>
                    <button onclick="updateCartQuantity('${item.id}', ${item.quantity + 1})">+</button>
                    <button onclick="removeFromCart('${item.id}')" style="margin-right: auto; color: var(--error);">حذف</button>
                </div>
            </div>
        </div>
    `).join('');

    const cartTotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    total.textContent = cartTotal.toFixed(2);
}

function showNotification(message) {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        background: var(--success);
        color: white;
        padding: 1rem 2rem;
        border-radius: 8px;
        box-shadow: var(--shadow-lg);
        z-index: 3000;
        font-weight: 600;
    `;
    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Make functions global for onclick handlers
window.addToCart = addToCart;
window.removeFromCart = removeFromCart;
window.updateCartQuantity = updateCartQuantity;

