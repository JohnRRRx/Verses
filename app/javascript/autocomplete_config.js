document.addEventListener("turbo:load", function () {
    const autoCompleteJS = new autoComplete({
      selector: "#autoComplete", // Ransackの検索欄をターゲットにする
      placeHolder: "検索",
      data: {
        src: async (query) => {
          try {
            const response = await fetch(`/posts/autocomplete?q=${query}`);
            const data = await response.json();
            return data.map(item => item.value); // 値のみを返す
          } catch (error) {
            console.error("Error fetching autocomplete data:", error);
            return [];
          }
        },
        cache: false,
      },
      resultsList: {
        element: (list, data) => {
          if (!data.results.length) {
            const message = document.createElement("div");
            message.setAttribute("class", "no_result");
            message.innerHTML = `<span>検索結果が見つかりません "${data.query}"</span>`;
            list.prepend(message);
          }
        },
        noResults: true,
      },
      resultItem: {
        highlight: true,
      },
      events: {
        input: {
          selection: (event) => {
            const selection = event.detail.selection.value;
            autoCompleteJS.input.value = selection;

            // 検索フォームを自動送信
            const form = document.querySelector(".search-form");
            form.submit();
          },
        },
      },
    });

    // Enterキーで通常のRansack検索を送信
    document.querySelector("#autoComplete").addEventListener("keydown", function (event) {
      if (event.key === "Enter") {
        const form = document.querySelector(".search-form");
        form.submit();
      }
    });
  });