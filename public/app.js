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