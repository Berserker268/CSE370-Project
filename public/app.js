function switchTab(tabName) {
    const filterSection = document.getElementById('filter-section');
    const leaderboard = document.getElementById('sidebar-right');
    const navButtons = document.querySelectorAll('.tab-btn');

    // Reset button colors
    navButtons.forEach(btn => btn.classList.remove('active'));

    if (tabName === 'foryou') {
        document.getElementById('btn-foryou').classList.add('active');
        if(filterSection) filterSection.style.display = 'block';
        if(leaderboard) leaderboard.classList.add('hidden');
    } 
    
    else if (tabName === 'trending') {
        document.getElementById('btn-trending').classList.add('active');
        if(filterSection) filterSection.style.display = 'none';
        if(leaderboard) leaderboard.classList.remove('hidden');
    }

    else if (tabName === 'following') {
        document.getElementById('btn-following').classList.add('active');
        if(filterSection) filterSection.style.display = 'none';
        if(leaderboard) leaderboard.classList.add('hidden');
    }
}

async function swipeCard(index, direction) {
    const card = document.getElementById(`card-${index}`);
    if (!card) return;

    const noteId = card.getAttribute('data-note-id');

    if (direction === 'right') {
        // MATCHING YOUR CSS: We only change the X-axis and add rotation
        card.style.transform = "translateX(200%) rotate(30deg)"; 
        card.style.opacity = "0";

        fetch(`/like-note/${noteId}`, { method: 'POST' })
            .catch(err => console.error("Save failed:", err));
            
    } else if (direction === 'left') {
        // Fly to the left
        card.style.transform = "translateX(-300%) rotate(-30deg)";
        card.style.opacity = "0";
    }

    setTimeout(() => {
        card.remove();
        checkEmptyStack();
    }, 600); // 600ms matches the 0.6s transition in your CSS
}
function checkEmptyStack() {
    const remainingCards = document.querySelectorAll('.note-card');
    const emptyMsg = document.getElementById('empty-msg');
    if (remainingCards.length === 0) {
        emptyMsg.style.display = 'flex';
    }
}
let isDragging = false;
let startX = 0;
let currentCard = null;

// Attach listeners to all cards
document.querySelectorAll('.note-card').forEach(card => {
    card.addEventListener('mousedown', startDrag);
});

function startDrag(e) {
    isDragging = true;
    currentCard = e.currentTarget;
    startX = e.clientX;
    currentCard.style.transition = 'none'; // Disable transition while dragging
    currentCard.style.cursor = 'grabbing';
}

window.addEventListener('mousemove', (e) => {
    if (!isDragging || !currentCard) return;

    const deltaX = e.clientX - startX;
    const rotation = deltaX / 10; // Add a slight tilt based on drag distance
    
    // We maintain the -50% to keep it centered while moving
    currentCard.style.transform = `translateX(calc(-50% + ${deltaX}px)) rotate(${rotation}deg)`;
});

window.addEventListener('mouseup', (e) => {
    if (!isDragging || !currentCard) return;
    isDragging = false;
    currentCard.style.cursor = 'grab';
    currentCard.style.transition = 'transform 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275), opacity 0.3s';

    const deltaX = e.clientX - startX;
    const threshold = 150; // Pixels needed to trigger a swipe

    if (Math.abs(deltaX) > threshold) {
        const noteId = currentCard.id.split('-')[1];
        if (deltaX > threshold) {
            swipeCard(noteId, 'right'); 
        }
        currentCard.remove(); 
        const remainingCards = document.querySelectorAll('.card');
        if (remainingCards.length === 0) {
            document.getElementById('empty-msg').style.display = 'flex';
        }
    } else {
        currentCard.style.transform = 'translateX(-50%) rotate(0deg)';
    }
    
    currentCard = null;
});

function checkInitialStack() {
    const cards = document.querySelectorAll('.note-card');
    const emptyMsg = document.getElementById('empty-msg');
    
    if (cards.length === 0 && emptyMsg) {
        emptyMsg.style.display = 'flex';
    }
}
window.onload = checkInitialStack;