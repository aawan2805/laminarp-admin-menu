let selectedPlayer = null; // Initialize selectedPlayer

window.addEventListener('message', function(event) {
    if (event.data.action === 'openAdminMenu') {
        document.getElementById('admin-menu').style.display = 'block';
        
        // Populate player list
        const playerSelect = document.getElementById('players');
        playerSelect.innerHTML = ''; // Clear previous entries

        event.data.players.forEach(player => {
            const option = document.createElement('option');
            option.value = player.id;
            option.text = player.name;
            playerSelect.appendChild(option);
        });

        // If there are players, set the first one as selected
        if (event.data.players.length > 0) {
            selectedPlayer = event.data.players[0].id; // Set the first player as selected
            playerSelect.value = selectedPlayer; // Update the select element
        }

        // Listen for changes in selected player
        playerSelect.addEventListener('change', function() {
            selectedPlayer = playerSelect.value;
        });
    }
});

function gotoPlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/gotoPlayer`, { 
            method: 'POST',
            body: JSON.stringify({ playerId: selectedPlayer })
        });
    }
}

function jailPlayer() {
    if (selectedPlayer) {
        let jailTime = prompt("Enter jail time in minutes:");
        fetch(`https://${GetParentResourceName()}/jailPlayer`, { 
            method: 'POST',
            body: JSON.stringify({ playerId: selectedPlayer, jailTime })
        });
    }
}

function banPlayer() {
    if (selectedPlayer) {
        let reason = prompt("Enter ban reason:");
        fetch(`https://${GetParentResourceName()}/banPlayer`, { 
            method: 'POST',
            body: JSON.stringify({ playerId: selectedPlayer, reason })
        });
    }
}

function revivePlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/revivePlayer`, { 
            method: 'POST',
            body: JSON.stringify({ playerId: selectedPlayer })
        });
    }
}

function closeMenu() {
    fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST' });
    document.getElementById('admin-menu').style.display = 'none';
}
