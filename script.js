// ============================================
// ENDY EDESON Calculator - JavaScript Logic
// ============================================

class Calculator {
    constructor() {
        // DOM Elements
        this.previousOperandElement = document.getElementById('previousOperand');
        this.currentOperandElement = document.getElementById('currentOperand');
        this.historyList = document.getElementById('historyList');
        this.historySidebar = document.getElementById('historySidebar');
        this.soundToggle = document.getElementById('soundToggle');
        this.copyBtn = document.getElementById('copyBtn');
        this.historyToggle = document.getElementById('historyToggle');
        this.clearHistoryBtn = document.getElementById('clearHistoryBtn');
        this.toast = document.getElementById('toast');
        this.loader = document.getElementById('loader');
        this.clickSound = document.getElementById('clickSound');

        // Calculator State
        this.previousOperand = '';
        this.currentOperand = '';
        this.operation = null;
        this.history = [];
        this.soundEnabled = true;
        this.historyVisible = false;

        // Load settings and history from localStorage
        this.loadSettings();
        this.loadHistory();

        // Initialize UI
        this.updateDisplay();
        this.setupEventListeners();
        this.hideLoader();

        // Set up keyboard support
        this.setupKeyboardSupport();
    }

    /**
     * Setup all event listeners
     */
    setupEventListeners() {
        // Number buttons
        document.querySelectorAll('.number-btn').forEach(btn => {
            btn.addEventListener('click', () => this.appendNumber(btn.dataset.number));
        });

        // Operator buttons
        document.querySelectorAll('.operator-btn').forEach(btn => {
            btn.addEventListener('click', () => this.setOperator(btn.dataset.operator));
        });

        // Function buttons
        document.querySelectorAll('[data-action="clear"]').forEach(btn => {
            btn.addEventListener('click', () => this.clear());
        });

        document.querySelectorAll('[data-action="delete"]').forEach(btn => {
            btn.addEventListener('click', () => this.delete());
        });

        document.querySelectorAll('[data-action="equals"]').forEach(btn => {
            btn.addEventListener('click', () => this.equals());
        });

        // Control buttons
        this.soundToggle.addEventListener('click', () => this.toggleSound());
        this.copyBtn.addEventListener('click', () => this.copyResult());
        this.historyToggle.addEventListener('click', () => this.toggleHistory());
        this.clearHistoryBtn.addEventListener('click', () => this.clearHistoryList());
    }

    /**
     * Setup keyboard support
     */
    setupKeyboardSupport() {
        document.addEventListener('keydown', (e) => {
            // Prevent default browser behavior for calculator keys
            if (['/', '*', '-', '+', 'Enter', 'Backspace', 'Delete'].includes(e.key)) {
                e.preventDefault();
            }

            // Numbers
            if (e.key >= '0' && e.key <= '9') {
                this.appendNumber(e.key);
            }

            // Decimal point
            if (e.key === '.') {
                this.appendNumber('.');
            }

            // Operators
            if (e.key === '/') {
                this.setOperator('÷');
            }
            if (e.key === '*') {
                this.setOperator('×');
            }
            if (e.key === '-') {
                this.setOperator('−');
            }
            if (e.key === '+') {
                this.setOperator('+');
            }

            // Percentage
            if (e.key === '%') {
                this.setOperator('%');
            }

            // Equals
            if (e.key === 'Enter' || e.key === '=') {
                this.equals();
            }

            // Clear
            if (e.key === 'Escape') {
                this.clear();
            }

            // Delete
            if (e.key === 'Backspace' || e.key === 'Delete') {
                this.delete();
            }

            // Copy result (Ctrl+C or Cmd+C)
            if ((e.ctrlKey || e.metaKey) && e.key === 'c') {
                this.copyResult();
            }
        });
    }

    /**
     * Append a number to the current operand
     */
    appendNumber(number) {
        this.playSound();

        // Prevent multiple decimal points
        if (number === '.' && this.currentOperand.includes('.')) {
            return;
        }

        // Limit length to prevent overflow
        if (this.currentOperand.length >= 15) {
            return;
        }

        this.currentOperand = this.currentOperand.toString() + number.toString();
        this.updateDisplay();
    }

    /**
     * Set the operation
     */
    setOperator(operator) {
        this.playSound();

        if (this.currentOperand === '') {
            return;
        }

        if (this.previousOperand !== '') {
            this.equals();
        }

        this.operation = operator;
        this.previousOperand = this.currentOperand;
        this.currentOperand = '';
        this.updateDisplay();
    }

    /**
     * Calculate the result
     */
    equals() {
        this.playSound();

        let computation;
        const prev = parseFloat(this.previousOperand);
        const current = parseFloat(this.currentOperand);

        if (isNaN(prev) || isNaN(current)) {
            return;
        }

        try {
            switch (this.operation) {
                case '+':
                    computation = prev + current;
                    break;
                case '−':
                    computation = prev - current;
                    break;
                case '×':
                    computation = prev * current;
                    break;
                case '÷':
                    if (current === 0) {
                        this.showError('Cannot divide by zero');
                        this.clear();
                        return;
                    }
                    computation = prev / current;
                    break;
                case '%':
                    computation = prev % current;
                    break;
                default:
                    return;
            }

            // Round to avoid floating point errors
            computation = Math.round(computation * 100000000) / 100000000;

            // Add to history
            const historyEntry = `${this.formatNumber(prev)} ${this.operation} ${this.formatNumber(current)} = ${this.formatNumber(computation)}`;
            this.addToHistory(historyEntry, computation);

            // Update display
            this.currentOperand = computation.toString();
            this.operation = null;
            this.previousOperand = '';
            this.updateDisplay();
        } catch (error) {
            this.showError('Calculation error');
            this.clear();
        }
    }

    /**
     * Clear the calculator
     */
    clear() {
        this.playSound();
        this.previousOperand = '';
        this.currentOperand = '';
        this.operation = null;
        this.updateDisplay();
    }

    /**
     * Delete the last digit
     */
    delete() {
        this.playSound();
        this.currentOperand = this.currentOperand.toString().slice(0, -1);
        this.updateDisplay();
    }

    /**
     * Update the display
     */
    updateDisplay() {
        this.currentOperandElement.innerText = this.formatDisplay(this.currentOperand) || '0';

        if (this.operation != null) {
            this.previousOperandElement.innerText =
                `${this.formatDisplay(this.previousOperand)} ${this.operation}`;
        } else {
            this.previousOperandElement.innerText = '';
        }
    }

    /**
     * Format number for display (add commas)
     */
    formatDisplay(number) {
        const stringNumber = number.toString();
        const integerDigits = parseFloat(stringNumber.split('.')[0]);
        const decimalDigits = stringNumber.split('.')[1];

        let integerDisplay;
        if (isNaN(integerDigits)) {
            integerDisplay = '';
        } else {
            integerDisplay = integerDigits.toLocaleString('en', {
                maximumFractionDigits: 0
            });
        }

        if (decimalDigits != null) {
            return `${integerDisplay}.${decimalDigits}`;
        } else {
            return integerDisplay;
        }
    }

    /**
     * Format number for history
     */
    formatNumber(number) {
        return Number(number).toLocaleString('en', {
            maximumFractionDigits: 8,
            useGrouping: true
        });
    }

    /**
     * Play sound effect
     */
    playSound() {
        if (this.soundEnabled && this.clickSound) {
            // Create a simple beep using Web Audio API for better support
            try {
                const audioContext = new (window.AudioContext || window.webkitAudioContext)();
                const oscillator = audioContext.createOscillator();
                const gainNode = audioContext.createGain();

                oscillator.connect(gainNode);
                gainNode.connect(audioContext.destination);

                oscillator.frequency.value = 800;
                oscillator.type = 'sine';

                gainNode.gain.setValueAtTime(0.1, audioContext.currentTime);
                gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.1);

                oscillator.start(audioContext.currentTime);
                oscillator.stop(audioContext.currentTime + 0.1);
            } catch (e) {
                // Fallback if Web Audio API is not available
            }
        }
    }

    /**
     * Toggle sound on/off
     */
    toggleSound() {
        this.soundEnabled = !this.soundEnabled;
        this.soundToggle.classList.toggle('active', this.soundEnabled);
        localStorage.setItem('soundEnabled', this.soundEnabled);
        this.showToast(this.soundEnabled ? 'Sound enabled' : 'Sound disabled');
    }

    /**
     * Copy result to clipboard
     */
    copyResult() {
        if (this.currentOperand === '') {
            this.showToast('Nothing to copy');
            return;
        }

        const textToCopy = this.currentOperand;
        navigator.clipboard.writeText(textToCopy).then(() => {
            this.showToast('Copied: ' + this.formatDisplay(textToCopy));
        }).catch(() => {
            this.showToast('Failed to copy');
        });
    }

    /**
     * Toggle history sidebar
     */
    toggleHistory() {
        this.historyVisible = !this.historyVisible;
        this.historySidebar.classList.toggle('hidden', !this.historyVisible);
        this.historyToggle.classList.toggle('active', this.historyVisible);
    }

    /**
     * Add entry to history
     */
    addToHistory(entry, result) {
        this.history.unshift({
            calculation: entry,
            result: result,
            timestamp: new Date().toLocaleTimeString()
        });

        // Keep only last 50 calculations
        if (this.history.length > 50) {
            this.history.pop();
        }

        this.saveHistory();
        this.updateHistoryDisplay();
    }

    /**
     * Update history display
     */
    updateHistoryDisplay() {
        if (this.history.length === 0) {
            this.historyList.innerHTML = '<p class="empty-message">No calculations yet</p>';
            return;
        }

        this.historyList.innerHTML = this.history.map((item, index) => `
            <div class="history-item" data-index="${index}" title="${item.timestamp}">
                <div>${item.calculation}</div>
                <div class="result" style="color: var(--button-bg); margin-top: 4px;">Result: ${this.formatNumber(item.result)}</div>
            </div>
        `).join('');

        // Add click listeners to history items
        document.querySelectorAll('.history-item').forEach(item => {
            item.addEventListener('click', () => {
                const index = item.dataset.index;
                this.currentOperand = this.history[index].result.toString();
                this.updateDisplay();
                this.showToast('Loaded from history');
            });
        });
    }

    /**
     * Clear history
     */
    clearHistoryList() {
        this.history = [];
        this.saveHistory();
        this.updateHistoryDisplay();
        this.showToast('History cleared');
    }

    /**
     * Show error message
     */
    showError(message) {
        this.showToast(message);
    }

    /**
     * Show toast notification
     */
    showToast(message) {
        this.toast.textContent = message;
        this.toast.classList.add('show');

        setTimeout(() => {
            this.toast.classList.remove('show');
        }, 2000);
    }

    /**
     * Save history to localStorage
     */
    saveHistory() {
        localStorage.setItem('calculatorHistory', JSON.stringify(this.history));
    }

    /**
     * Load history from localStorage
     */
    loadHistory() {
        const saved = localStorage.getItem('calculatorHistory');
        if (saved) {
            try {
                this.history = JSON.parse(saved);
                this.updateHistoryDisplay();
            } catch (e) {
                this.history = [];
            }
        }
    }

    /**
     * Save settings to localStorage
     */
    saveSettings() {
        localStorage.setItem('soundEnabled', this.soundEnabled);
    }

    /**
     * Load settings from localStorage
     */
    loadSettings() {
        const saved = localStorage.getItem('soundEnabled');
        if (saved !== null) {
            this.soundEnabled = saved === 'true';
        }
        this.soundToggle.classList.toggle('active', this.soundEnabled);
    }

    /**
     * Hide the loading animation
     */
    hideLoader() {
        setTimeout(() => {
            this.loader.classList.add('hidden');
        }, 800);
    }
}

// ============================================
// Initialize Calculator on Page Load
// ============================================
document.addEventListener('DOMContentLoaded', () => {
    window.calculator = new Calculator();

    // Add smooth page transitions
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.opacity = '1';
        document.body.style.transition = 'opacity 0.5s ease-in';
    }, 100);
});

// ============================================
// Utility Functions
// ============================================

/**
 * Handle window resize for responsive behavior
 */
window.addEventListener('resize', () => {
    // Adjust calculator if needed
    const width = window.innerWidth;
    if (width < 480) {
        document.body.style.padding = '10px';
    } else if (width < 768) {
        document.body.style.padding = '15px';
    } else {
        document.body.style.padding = '20px';
    }
});

/**
 * Prevent zoom on double tap (for better mobile experience)
 */
let lastTouchEnd = 0;
document.addEventListener('touchend', (e) => {
    const now = Date.now();
    if (now - lastTouchEnd <= 300) {
        e.preventDefault();
    }
    lastTouchEnd = now;
}, false);

/**
 * Handle app visibility (pause sounds if page is hidden)
 */
document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        // Page is hidden
    } else {
        // Page is visible
    }
});

// ============================================
// Service Worker Registration (Optional PWA)
// ============================================
if ('serviceWorker' in navigator) {
    // You can add service worker registration here for offline support
    // navigator.serviceWorker.register('sw.js');
}

// ============================================
// Error Handling
// ============================================
window.addEventListener('error', (event) => {
    console.error('Application Error:', event.error);
});

window.addEventListener('unhandledrejection', (event) => {
    console.error('Unhandled Promise Rejection:', event.reason);
});
