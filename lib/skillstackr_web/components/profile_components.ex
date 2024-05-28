defmodule SkillstackrWeb.ProfileComponents do
  use Phoenix.Component

  def github_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} viewBox="0 0 24 24">
      <path
        fill="currentColor"
        d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5c.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34c-.46-1.16-1.11-1.47-1.11-1.47c-.91-.62.07-.6.07-.6c1 .07 1.53 1.03 1.53 1.03c.87 1.52 2.34 1.07 2.91.83c.09-.65.35-1.09.63-1.34c-2.22-.25-4.55-1.11-4.55-4.92c0-1.11.38-2 1.03-2.71c-.1-.25-.45-1.29.1-2.64c0 0 .84-.27 2.75 1.02c.79-.22 1.65-.33 2.5-.33s1.71.11 2.5.33c1.91-1.29 2.75-1.02 2.75-1.02c.55 1.35.2 2.39.1 2.64c.65.71 1.03 1.6 1.03 2.71c0 3.82-2.34 4.66-4.57 4.91c.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2"
      />
    </svg>
    """
  end

  def linkedin_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} viewBox="0 0 24 24">
      <path
        fill="currentColor"
        d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2zm-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.32 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93zM6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37z"
      />
    </svg>
    """
  end

  def website_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} viewBox="0 0 256 256">
      <path
        fill="currentColor"
        d="M128 24a104 104 0 1 0 104 104A104.12 104.12 0 0 0 128 24m87.62 96h-39.83c-1.79-36.51-15.85-62.33-27.38-77.6a88.19 88.19 0 0 1 67.22 77.6ZM96.23 136h63.54c-2.31 41.61-22.23 67.11-31.77 77c-9.55-9.9-29.46-35.4-31.77-77m0-16c2.31-41.61 22.23-67.11 31.77-77c9.55 9.93 29.46 35.43 31.77 77Zm11.36-77.6C96.06 57.67 82 83.49 80.21 120H40.37a88.19 88.19 0 0 1 67.22-77.6M40.37 136h39.84c1.82 36.51 15.85 62.33 27.38 77.6A88.19 88.19 0 0 1 40.37 136m108 77.6c11.53-15.27 25.56-41.09 27.38-77.6h39.84a88.19 88.19 0 0 1-67.18 77.6Z"
      />
    </svg>
    """
  end

  def pdf_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width={@size} height={@size} viewBox="0 0 1024 1024">
      <path
        fill="currentColor"
        d="M854.6 288.7c6 6 9.4 14.1 9.4 22.6V928c0 17.7-14.3 32-32 32H192c-17.7 0-32-14.3-32-32V96c0-17.7 14.3-32 32-32h424.7c8.5 0 16.7 3.4 22.7 9.4zM790.2 326L602 137.8V326zM633.22 637.26c-15.18-.5-31.32.67-49.65 2.96c-24.3-14.99-40.66-35.58-52.28-65.83l1.07-4.38l1.24-5.18c4.3-18.13 6.61-31.36 7.3-44.7c.52-10.07-.04-19.36-1.83-27.97c-3.3-18.59-16.45-29.46-33.02-30.13c-15.45-.63-29.65 8-33.28 21.37c-5.91 21.62-2.45 50.07 10.08 98.59c-15.96 38.05-37.05 82.66-51.2 107.54c-18.89 9.74-33.6 18.6-45.96 28.42c-16.3 12.97-26.48 26.3-29.28 40.3c-1.36 6.49.69 14.97 5.36 21.92c5.3 7.88 13.28 13 22.85 13.74c24.15 1.87 53.83-23.03 86.6-79.26c3.29-1.1 6.77-2.26 11.02-3.7l11.9-4.02c7.53-2.54 12.99-4.36 18.39-6.11c23.4-7.62 41.1-12.43 57.2-15.17c27.98 14.98 60.32 24.8 82.1 24.8c17.98 0 30.13-9.32 34.52-23.99c3.85-12.88.8-27.82-7.48-36.08c-8.56-8.41-24.3-12.43-45.65-13.12M385.23 765.68v-.36l.13-.34a55 55 0 0 1 5.6-10.76c4.28-6.58 10.17-13.5 17.47-20.87c3.92-3.95 8-7.8 12.79-12.12c1.07-.96 7.91-7.05 9.19-8.25l11.17-10.4l-8.12 12.93c-12.32 19.64-23.46 33.78-33 43c-3.51 3.4-6.6 5.9-9.1 7.51a16.4 16.4 0 0 1-2.61 1.42c-.41.17-.77.27-1.13.3a2.2 2.2 0 0 1-1.12-.15a2.07 2.07 0 0 1-1.27-1.91M511.17 547.4l-2.26 4l-1.4-4.38c-3.1-9.83-5.38-24.64-6.01-38c-.72-15.2.49-24.32 5.29-24.32c6.74 0 9.83 10.8 10.07 27.05c.22 14.28-2.03 29.14-5.7 35.65zm-5.81 58.46l1.53-4.05l2.09 3.8c11.69 21.24 26.86 38.96 43.54 51.31l3.6 2.66l-4.39.9c-16.33 3.38-31.54 8.46-52.34 16.85c2.17-.88-21.62 8.86-27.64 11.17l-5.25 2.01l2.8-4.88c12.35-21.5 23.76-47.32 36.05-79.77zm157.62 76.26c-7.86 3.1-24.78.33-54.57-12.39l-7.56-3.22l8.2-.6c23.3-1.73 39.8-.45 49.42 3.07c4.1 1.5 6.83 3.39 8.04 5.55a4.64 4.64 0 0 1-1.36 6.31a6.7 6.7 0 0 1-2.17 1.28"
      />
    </svg>
    """
  end

  def tech_badge(assigns) do
    assigns = assign(assigns, :size, Map.get(assigns, :size, 25))

    ~H"""
    <img src={"https://cdn.simpleicons.org/#{@tech}"} width={@size} alt={"#{@tech}"} />
    """
  end

  def project_card(assigns) do
    ~H"""
    <div class="flex flex-col bg-white border shadow-sm rounded-xl dark:bg-neutral-900 dark:border-neutral-700 dark:shadow-neutral-700/70">
      <img
        class="w-full h-auto rounded-t-xl"
        src="https://images.unsplash.com/photo-1680868543815-b8666dba60f7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2532&q=80"
        alt="Image Description"
      />
      <div class="p-4 md:p-5">
        <h3 class="text-lg font-bold text-gray-800 dark:text-white">
          Card title
        </h3>
        <div class="flex gap-2 mt-1 mb-2">
          <.tech_badge tech={:typescript} size={18} />
          <.tech_badge tech={:svelte} size={18} />
          <.tech_badge tech={:supabase} size={18} />
        </div>
        <p class="mt-1 text-gray-500 dark:text-neutral-400">
          Some quick example text to build on the card title and make up the bulk of the card's content.
        </p>
        <a class="text-blue-600 hover:underline hover:decoration-blue-600" href="#">
          Code
        </a>
        <span class="text-gray-300 mx-1">|</span>
        <a class="text-blue-600 hover:underline hover:decoration-blue-600" href="#">
          Website
        </a>
      </div>
    </div>
    """
  end

  def job_accordion(assigns) do
    ~H"""
    <div class="hs-accordion-group">
      <div
        class="hs-accordion bg-white border -mt-px first:rounded-t-lg last:rounded-b-lg dark:bg-neutral-800 dark:border-neutral-700"
        id="hs-bordered-heading-two"
      >
        <button
          class="hs-accordion-toggle hs-accordion-active:text-blue-600 inline-flex items-center gap-x-3 w-full font-semibold text-start text-gray-800 py-4 px-5 hover:text-gray-500 disabled:opacity-50 disabled:pointer-events-none dark:hs-accordion-active:text-blue-500 dark:text-neutral-200 dark:hover:text-neutral-400 dark:focus:outline-none dark:focus:text-neutral-400"
          aria-controls="hs-basic-bordered-collapse-two"
        >
          <svg
            class="hs-accordion-active:hidden block size-3.5"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M5 12h14"></path>
            <path d="M12 5v14"></path>
          </svg>
          <svg
            class="hs-accordion-active:block hidden size-3.5"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M5 12h14"></path>
          </svg>
          Accordion #2
        </button>
        <div
          id="hs-basic-bordered-collapse-two"
          class="hs-accordion-content hidden w-full overflow-hidden transition-[height] duration-300"
          aria-labelledby="hs-bordered-heading-two"
        >
          <div class="pb-4 px-5">
            <p class="text-gray-800 dark:text-neutral-200">
              <em>This is the second item's accordion body.</em>
              It is hidden by default, until the collapse plugin adds
              the appropriate classes that we use to style each element. These classes control the overall appearance, as
              well as the showing and hiding via CSS transitions.
            </p>
          </div>
        </div>
      </div>

      <div
        class="hs-accordion bg-white border -mt-px first:rounded-t-lg last:rounded-b-lg dark:bg-neutral-800 dark:border-neutral-700"
        id="hs-bordered-heading-three"
      >
        <button
          class="hs-accordion-toggle hs-accordion-active:text-blue-600 inline-flex items-center gap-x-3 w-full font-semibold text-start text-gray-800 py-4 px-5 hover:text-gray-500 disabled:opacity-50 disabled:pointer-events-none dark:hs-accordion-active:text-blue-500 dark:text-neutral-200 dark:hover:text-neutral-400 dark:focus:outline-none dark:focus:text-neutral-400"
          aria-controls="hs-basic-bordered-collapse-three"
        >
          <svg
            class="hs-accordion-active:hidden block size-3.5"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M5 12h14"></path>
            <path d="M12 5v14"></path>
          </svg>
          <svg
            class="hs-accordion-active:block hidden size-3.5"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M5 12h14"></path>
          </svg>
          Accordion #3
        </button>
        <div
          id="hs-basic-bordered-collapse-three"
          class="hs-accordion-content hidden w-full overflow-hidden transition-[height] duration-300"
          aria-labelledby="hs-bordered-heading-three"
        >
          <div class="pb-4 px-5">
            <p class="text-gray-800 dark:text-neutral-200">
              <em>This is the first item's accordion body.</em>
              It is hidden by default, until the collapse plugin adds
              the appropriate classes that we use to style each element. These classes control the overall appearance, as
              well as the showing and hiding via CSS transitions.
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def profile_link(%{site: :github} = assigns) do
    ~H"""
      <a href={@url} class="flex items-center gap-2" target="_blank">
        <.github_icon size={20} /> kekw-kekw
      </a>
    """
  end

  def profile_link(%{site: :linkedin} = assigns) do
    ~H"""
      <a href={@url} class="flex items-center gap-2" target="_blank">
        <.linkedin_icon size={20} /> kekw-kekw
      </a>
    """
  end

  def profile_link(%{site: :website} = assigns) do
    ~H"""
      <a href={@url} class="flex items-center gap-2" target="_blank">
        <.website_icon size={20} /> kekw-kekw
      </a>
    """
  end

  def profile_link(%{site: :resume} = assigns) do
    ~H"""
      <a href={@url} class="flex items-center gap-2" target="_blank">
        <.pdf_icon size={20} /> kekw-kekw
      </a>
    """
  end

end
