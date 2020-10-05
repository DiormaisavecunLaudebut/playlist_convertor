const inputSearch = document.getElementById('input-search')
const playlists = document.querySelectorAll('.playlist-row')

const playlistSearch = () => {
  playlists.forEach((playlist) => {
    if (playlist.dataset.name.includes(inputSearch.value)) {
      playlist.classList.add('d-flex')
      playlist.classList.remove('d-none')
    } else {
      playlist.classList.remove('d-flex')
      playlist.classList.add('d-none')
    }

  })
}

const listenPlaylistSearch = () => {
  if (inputSearch) inputSearch.addEventListener('input', playlistSearch)
}

export { listenPlaylistSearch }
