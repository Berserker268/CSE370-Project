const forYouContainer = document.getElementById('foryou-container');
const trendingContainer = document.getElementById('trending-container');

function switchTab(tabName) {
    const filterSection = document.getElementById('filter-section');
    const leaderboard = document.getElementById('sidebar-right');
    const navButtons = document.querySelectorAll('.tab-btn');

    navButtons.forEach(btn => btn.classList.remove('active'));

    if (tabName === 'foryou') {
        document.getElementById('btn-foryou').classList.add('active');
        if(filterSection) filterSection.style.display = 'block';
        if(leaderboard) leaderboard.classList.add('hidden');
        forYouContainer.style.display = 'block';
        trendingContainer.style.display = 'none';
    } 
    
    else if (tabName === 'trending') {
        document.getElementById('btn-trending').classList.add('active');
        if(filterSection) filterSection.style.display = 'none';
        if(leaderboard) leaderboard.classList.remove('hidden');
        forYouContainer.style.display = 'none';
        trendingContainer.style.display = 'block';
    }

}

async function swipeCard(index, direction, isTrending = false) {
    const idPrefix = isTrending ? 'trending-card-' : 'card-';
    const card = document.getElementById(`${idPrefix}${index}`);
    if (!card) return;

    const noteId = card.getAttribute('data-note-id');

    if (direction === 'right') {
        card.style.transform = "translateX(200%) rotate(30deg)"; 
        card.style.opacity = "0";

        fetch(`/like-note/${noteId}`, { method: 'POST' })
            .catch(err => console.error("Save failed:", err));
        
        const sameNotes = document.querySelectorAll(`[data-note-id="${noteId}"]`);
        sameNotes.forEach(note => {
            note.style.opacity = "0";
            note.style.pointerEvents = "none";
            setTimeout(() => note.remove(), 600);
        });
            
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
    //const forYouRemaining = document.querySelectorAll('#foryou-container .note-card').length;
    //const trendingRemaining = document.querySelectorAll('#trending-container .note-card').length;
    const remainingCards = document.querySelectorAll('.note-card');
    const emptyMsg = document.getElementById('empty-msg');
    if (remainingCards.length === 0) {
        emptyMsg.style.display = 'flex';
    }
}
let isDragging = false;
let startX = 0;
let currentCard = null;

document.querySelectorAll('.note-card').forEach(card => {
    card.addEventListener('mousedown', startDrag);
});

function startDrag(e) {
    isDragging = true;
    currentCard = e.currentTarget;
    startX = e.clientX;
    currentCard.style.transition = 'none';
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
        const isTrending = currentCard.id.includes('trending');
        const idParts = currentCard.id.split('-');
        const index = idParts[idParts.length - 1];

        if (deltaX > threshold) {
            swipeCard(index, 'right', isTrending); 
        } else {
            swipeCard(index, 'left', isTrending);
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