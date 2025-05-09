


// translate.js - isolated scope
(function() {


	let translateButton = null;
	let translateIcon = null;
	let translateContainer = null;
	let translateSelect = null;
	let translateSelectOptions = null;
//fas fa-language
	const translateWidget = `<div class="floating-translation" id="cdsGoogleTranslateContainer" role="heading" aria-level="2">
				<label>
				<span class="sr-only" role="presentation">Language</span>
					<i id="cdsGoogleTranslateIcon" class="fas fa-language text-white" style="font-size:3rem" title="Language Icon"></i>
				<div class="select-container">
					<select name="Language" id="languageDropdown" class="notranslate">

					</select>
				</div>
				</label>
				<button type="button" id="cdsGoogleTranslateButton"  class="btn btn-form-submit"><span class="sr-only">Apply Translation</span>
					<i class="fas fa-arrow-right" title="Apply Translation"></i>
				</button>
			</div>
	`;

	const googleTranslateWidget = `<div class="language-selector">
        <div class="google-translate-container">
            <div id="google_translate_element"></div>
        </div>
    </div>`;

	const googleTranslateScript = document.createElement('script');

	googleTranslateScript.src = "//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit";


	document.body.insertAdjacentHTML('beforeend', translateWidget);
	document.body.insertAdjacentHTML('beforeend', googleTranslateWidget);
	document.body.appendChild(googleTranslateScript);
	

	document.addEventListener('DOMContentLoaded', () => {

		translateButton = document.getElementById("cdsGoogleTranslateButton");
		translateIcon = document.getElementById("cdsGoogleTranslateIcon");	
		translateContainer = document.getElementById("cdsGoogleTranslateContainer");
		translateSelect = document.getElementById("languageDropdown");

		translateButton.addEventListener("click", translatePage);
		translateIcon.addEventListener("click", collapsedExpanded);

		googleTranslateAddLanguages();


		translateSelectOptions =  Array.from(translateSelect.querySelectorAll("option"));

		setTimeout(function() {
			
			setMutationObserver();
		},1500); 
	



	});


	function setMutationObserver() {
		const targetElement = document.getElementById("google_translate_element").querySelector("a span");

		//initializes the dropdown with the current (loaded) google translate language (for re-visits)?
		if(targetElement && targetElement.textContent!="") {
			const hasValue = Array.from(translateSelectOptions).some(option => option.textContent.trim() === targetElement.textContent);
			if(hasValue) {
				translateSelect.value = targetElement.textContent;
			}
		}
		
		// Create a MutationObserver instance
		const observer = new MutationObserver((mutationsList, observer) => {
			// Loop through all mutations that just occurred
			mutationsList.forEach(mutation => {
				if (mutation.type === 'childList') {
				// Handle child node changes (e.g., content update)
			  	//console.log("Content changed:", mutation.target.textContent);
				const value = mutation.target.textContent;
				if(translateSelect.value != value) {
					const hasValue = Array.from(translateSelectOptions).some(option => option.textContent.trim() === value);
					if(hasValue) {
						translateSelect.value = value;
					} else {
						if(value == 'Select Language') {
							translateSelect.value = "English";
						}
					}
				}

				}
			});
		});
		const config = { childList: true, subtree: true };
		observer.observe(targetElement, config);
	}

	function collapsedExpanded() {
		
		translateContainer.classList.toggle("floating-translation-expanded");	
	}

	function googleTranslateAddLanguages() {

		const languageDropdown = document.getElementById("languageDropdown");
		const featuredOptions = `<optgroup label="Frequently Used">
					<option value="English">English</option>
					<option value="Spanish">Español</option>
					<option value="Arabic">العربية</option>
					<option value="Chinese (Simplified)">简化字</option>
					<option value="French">Français</option>
					<option value="Haitian">Kreyòl ayisyen</option>
					<option value="Korean">한국어</option>
					<option value="Polish">Polskie</option>
					<option value="Russian">Pусский</option>
					<option value="Urdu">اردو</option>
					<option value="Wolof">Wollof</option>
				</optgroup>`
		const languages = [
					"Afrikaans", "Albanian", "Amharic", "Arabic", "Armenian", "Azerbaijani", 
					"Basque", "Belarusian", "Bengali", "Bosnian", "Bulgarian", "Catalan", 
					"Cebuano", "Chinese (Simplified)", "Chinese (Traditional)", "Corsican", 
					"Croatian", "Czech", "Danish", "Dutch", "English", "Esperanto", "Estonian", 
					"Finnish", "French", "Frisian", "Galician", "Georgian", "German", "Greek", 
					"Gujarati", "Haitian Creole", "Hausa", "Hawaiian", "Hebrew", "Hindi", 
					"Hmong", "Hungarian", "Icelandic", "Igbo", "Indonesian", "Irish", 
					"Italian", "Japanese", "Javanese", "Kannada", "Kazakh", "Khmer", 
					"Kinyarwanda", "Korean", "Kurdish", "Kyrgyz", "Lao", "Latin", "Latvian", 
					"Lithuanian", "Luxembourgish", "Macedonian", "Malagasy", "Malay", 
					"Malayalam", "Maltese", "Maori", "Marathi", "Mongolian", "Myanmar (Burmese)", 
					"Nepali", "Norwegian", "Odia (Oriya)", "Pashto", "Persian", "Polish", 
					"Portuguese", "Punjabi", "Romanian", "Russian", "Samoan", "Scots Gaelic", 
					"Serbian", "Sesotho", "Shona", "Sindhi", "Sinhala", "Slovak", "Slovenian", 
					"Somali", "Spanish", "Sundanese", "Swahili", "Swedish", "Tagalog (Filipino)", 
					"Tajik", "Tamil", "Tatar", "Telugu", "Thai", "Tigrinya", "Turkish", 
					"Turkmen", "Ukrainian", "Urdu", "Uyghur", "Uzbek", "Vietnamese", "Welsh", 
					"Xhosa", "Yiddish", "Yoruba", "Zulu",
					"Abkhaz", "Acehnese", "Acholi", "Afar", "Alur", "Avar", "Awadhi", "Balinese", 
					"Baluchi", "Baoulé", "Bashkir", "Batak Karo", "Batak Simalungun", 
					"Batak Toba", "Bemba", "Betawi", "Bikol", "Breton", "Buryat", "Cantonese", 
					"Chamorro", "Chechen", "Chuukese", "Chuvash", "Crimean Tatar", "Dari", 
					"Dinka", "Dombe", "Dyula", "Dzongkha", "Faroese", "Fijian", "Fon", 
					"Friulian", "Fulani", "Ga", "Hakha Chin", "Hiligaynon", "Hunsrik", "Iban", 
					"Jamaican Patois", "Jingpo", "Kalaallisut", "Kanuri", "Kapampangan", "Khasi", 
					"Kiga", "Kikongo", "Kituba", "Kokborok", "Komi", "Latgalian", "Ligurian", 
					"Limburgish", "Lombard", "Luo", "Madurese", "Makassar", "Malay (Jawi)", 
					"Mam", "Manx", "Marshallese", "Marwadi", "Mauritian Creole", "Meadow Mari", 
					"Minang", "Nahuatl (Eastern Huasteca)", "Ndau", "Ndebele (South)", 
					"Nepalbhasa (Newari)", "NKo", "Nuer", "Occitan", "Ossetian", "Pangasinan", 
					"Papiamento", "Portuguese (Portugal)", "Punjabi (Shahmukhi)", "Q'eqchi'", 
					"Romani", "Rundi", "Sami (North)", "Sango", "Santali", "Seychellois Creole", 
					"Shan", "Sicilian", "Silesian", "Susu", "Swati", "Tahitian", "Tamazight", 
					"Tamazight (Tifinagh)", "Tetum", "Tibetan", "Tiv", "Tok Pisin", "Tongan", 
					"Tswana", "Tulu", "Tumbuka", "Tuvan", "Udmurt", "Venda", "Venetian", 
					"Waray", "Wolof", "Yakut", "Yucatec Maya", "Zapotec"
				];
				
				const languageOptions = `<optgroup label="Google Translate">` + 
					languages.map(lang => `<option value="${lang}">${lang}</option>`).join('') +
					`</optgroup>`;

				document.getElementById("languageDropdown").innerHTML = featuredOptions + languageOptions;



	}

	function translatePage(){
		
		var theLanguage=document.getElementById("languageDropdown").options[document.getElementById("languageDropdown").selectedIndex].value;
		console.log(theLanguage);

		if (theLanguage == "separator") { return; }
		if(theLanguage.length>0){
			if($('.skiptranslate').contents().find('span.text:contains('+theLanguage+')').get(0)){
				const el = $('.skiptranslate').contents().find('span.text:contains('+theLanguage+')').get(0);
				const elLink  = $(el).closest('a');
				if(elLink.length>0){
					elLink.get(0).click();
				}else {
					$('.skiptranslate').contents().find('span.text:contains('+theLanguage+')').get(0).click();
				}

			}else{
				//alert('not found');
			}
		}
	}

})();


function googleTranslateElementInit() {

	new google.translate.TranslateElement({
		pageLanguage: 'en',
		layout: google.translate.TranslateElement.InlineLayout.SIMPLE
	}, 'google_translate_element');


	

}
