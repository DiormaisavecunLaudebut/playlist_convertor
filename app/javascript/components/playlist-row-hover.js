const playlistRows = Array.from(document.querySelectorAll('.playlist-row'))
const nextLink = document.getElementById('next-link')

const rowHover = () => {
  const cover = event.currentTarget.querySelector('.playlist-cover')
  const texts = Array.from(event.currentTarget.querySelector('.playlist-details').children)

  event.currentTarget.classList.toggle('inner-shadow')
  cover.classList.toggle('cover-filter')
}

const toggleSelection = (row) => {
  const texts = Array.from(row.querySelector('.playlist-details').children)

  row.classList.toggle('row-selected')
  texts.forEach(e => e.classList.toggle('text-selected'))
}

const rowSelect = () => {
  const lastRowSelected = document.querySelector('.row-selected')

  if (lastRowSelected) toggleSelection(lastRowSelected)

  toggleSelection(event.currentTarget)
  nextLink.href = event.currentTarget.querySelector('a').href
  nextLink.classList.add('link-enable')
}

const listenPlaylistHover = () => {
  if (playlistRows) {
    playlistRows.forEach(e => e.addEventListener('mouseover', rowHover))
    playlistRows.forEach(e => e.addEventListener('click', rowSelect))
    playlistRows.forEach(e => e.addEventListener('mouseout', rowHover))
  }
}

export { listenPlaylistHover }
