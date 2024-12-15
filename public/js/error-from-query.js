const containerEl = document.querySelector("#error-container");

const errorMessages = {
	emailInUse: `Email is already in use. Please <a href="/login">log in</a> instead.`,
	invalidPassword: `Invalid password. Password must contain: 
<ul>
  <li>A mimimum of 8 characters</li>
  <li>At least one uppercase letter</li>
  <li>At least one lowercase letter</li>
  <li>At least one digit</li>
  <li>At least one non-alphabetic character</li>
</ul>`,
	invalidEmailOrPassword: "Invalid email or password.",
};

function checkErrorFromQuery() {
	const params = new URLSearchParams(window.location.search);
	const error = params.get("error");
	if (!error) return;

	const errorMessage = errorMessages[error];
	if (!errorMessage) return;

	containerEl.innerHTML = errorMessage;
	containerEl.style.display = "block";
}

checkErrorFromQuery();
