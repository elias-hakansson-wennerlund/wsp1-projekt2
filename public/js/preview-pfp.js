const profilePicture = document.querySelector("#profile-picture");
const pictureInput = document.querySelector("#picture-input");

pictureInput.addEventListener("change", (e) => {
	const file = e.target.files[0];

	if (!file) return;

	const reader = new FileReader();

	reader.onload = (e) => {
		profilePicture.src = e.target.result;
		profilePicture.style.display = "block";
	};

	reader.readAsDataURL(file);
});
