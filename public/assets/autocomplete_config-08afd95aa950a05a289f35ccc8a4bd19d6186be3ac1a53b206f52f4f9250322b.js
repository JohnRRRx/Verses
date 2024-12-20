document.addEventListener("turbo:load", function () {
    const autoCompleteJS = new autoComplete({
      selector: "#autoComplete",
      placeHolder: "検索",
      data: {
        src: async (query) => {
          try {
            const response = await fetch(`/posts/autocomplete?q=${query}`);
            const data = await response.json();
            return data.map((item) => item.value);
          } catch (error) {
            console.error("Error fetching autocomplete data:", error);
            return [];
          }
        },
        cache: false,
      },
      resultItem: {
        highlight: true,
      },
      events: {
        input: {
          selection: (event) => {
            const selection = event.detail.selection.value;
            autoCompleteJS.input.value = selection;
  
            // フォームを送信
            const form = document.querySelector(".search-form");
            form.submit();
          },
        },
      },
    });
    
    document.querySelector("#autoComplete").addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
          const form = document.querySelector(".search-form");
          form.submit(); // 通常の検索フォーム送信を実行
        }
    });
});
