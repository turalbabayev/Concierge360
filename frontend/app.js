document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const togglePasswordBtn = document.querySelector('.toggle-password');
    const loginButton = document.querySelector('.login-button');

    // Toggle password visibility
    togglePasswordBtn.addEventListener('click', () => {
        const type = passwordInput.type === 'password' ? 'text' : 'password';
        passwordInput.type = type;
        togglePasswordBtn.innerHTML = type === 'password' 
            ? '<i class="fas fa-eye"></i>' 
            : '<i class="fas fa-eye-slash"></i>';
    });

    // Form submission
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Reset error messages
        document.querySelectorAll('.error-message').forEach(el => {
            el.textContent = '';
            el.classList.remove('show');
        });

        // Validate inputs
        let hasError = false;
        if (!emailInput.value) {
            showError(emailInput, 'Email is required');
            hasError = true;
        } else if (!isValidEmail(emailInput.value)) {
            showError(emailInput, 'Please enter a valid email');
            hasError = true;
        }

        if (!passwordInput.value) {
            showError(passwordInput, 'Password is required');
            hasError = true;
        } else if (passwordInput.value.length < 6) {
            showError(passwordInput, 'Password must be at least 6 characters');
            hasError = true;
        }

        if (hasError) return;

        // Show loading state
        loginButton.classList.add('loading');

        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 1500));
            
            // Handle successful login
            console.log('Logged in successfully');
            
        } catch (error) {
            showError(passwordInput, 'Invalid email or password');
        } finally {
            loginButton.classList.remove('loading');
        }
    });

    // Helper functions
    function showError(input, message) {
        const errorElement = input.closest('.form-group').querySelector('.error-message');
        errorElement.textContent = message;
        errorElement.classList.add('show');
        input.classList.add('error');
    }

    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    // Input focus effects
    document.querySelectorAll('.input-group input').forEach(input => {
        input.addEventListener('focus', () => {
            input.closest('.form-group').querySelector('.error-message').classList.remove('show');
            input.classList.remove('error');
        });
    });
}); 