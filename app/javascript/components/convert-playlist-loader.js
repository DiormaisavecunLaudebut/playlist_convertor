const icons = document.querySelectorAll('.destination-icon')
const destinationSection = document.getElementById('destination')

const displayLoader = () => {
  Array.from(destinationSection.children).forEach(e => e.remove())

  destinationSection.insertAdjacentHTML('afterbegin', `<div class=" mt-5 loader">
  <span>L</span>
  <span>O</span>
  <span>A</span>
  <span>D</span>
  <span>I</span>
  <span>N</span>
  <span>G</span>

  <div class="covers">
    <span></span>
    <span></span>
    <span></span>
    <span></span>
    <span></span>
    <span></span>
    <span></span>
  </div>
</div>`)
}

const listenConvertPlaylistDestination = () => {
  if (icons) icons.forEach(e => e.addEventListener('click', displayLoader))
}


export { listenConvertPlaylistDestination }
