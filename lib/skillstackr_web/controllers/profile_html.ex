defmodule SkillstackrWeb.ProfileHTML do
  @moduledoc """
  This module contains pages rendered by ProfileController.

  See the `profile_html` directory for all templates available.
  """
  use SkillstackrWeb, :html

  embed_templates "profile_html/*"

  def project_card(assigns) do
    ~H"""
    <div class="flex flex-col bg-white border shadow-sm rounded-xl dark:bg-neutral-900 dark:border-neutral-700 dark:shadow-neutral-700/70">
      <img class="w-full h-auto rounded-t-xl" src={@project.cover_url} alt={@project.title} />
      <div class="p-4 md:p-5">
        <h3 class="text-lg font-bold text-gray-800 dark:text-white">
          <%= @project.title %>
        </h3>
        <div class="flex gap-2 mt-1 mb-2">
          <TechnologyComponents.tech_badge :for={tech <- @project.technologies} tech={tech} size={18} />
        </div>
        <p class="mt-1 text-gray-500 dark:text-neutral-400">
          <%= @project.description %>
        </p>
        <a
          class="text-blue-600 hover:underline hover:decoration-blue-600"
          href={@project.code_url}
          target="_blank"
        >
          Code
        </a>
        <span class="text-gray-400 dark:text-gray-600 font-light mx-1">|</span>
        <a
          class="text-blue-600 hover:underline hover:decoration-blue-600"
          href={@project.code_url}
          target="_blank"
        >
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
        :for={job <- @experience}
        class="hs-accordion bg-white border -mt-px first:rounded-t-lg last:rounded-b-lg dark:bg-neutral-800 dark:border-neutral-700"
        id={"hs-bordered-heading-#{job.id}"}
      >
        <button
          class="hs-accordion-toggle hs-accordion-active:text-blue-600 inline-flex items-center justify-between gap-x-3 w-full font-semibold text-start text-gray-800 py-4 px-5 hover:text-gray-500 disabled:opacity-50 disabled:pointer-events-none dark:hs-accordion-active:text-blue-500 dark:text-neutral-200 dark:hover:text-neutral-400 dark:focus:outline-none dark:focus:text-neutral-400"
          aria-controls={"hs-basic-bordered-collapse-#{job.id}"}
        >
          <div class="flex items-center gap-2">
            <svg
              class="hs-accordion-active:hidden block size-4"
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
              <path d="m6 9 6 6 6-6"></path>
            </svg>
            <svg
              class="hs-accordion-active:block hidden size-4"
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
              <path d="m18 15-6-6-6 6"></path>
            </svg>
            <h3><%= job.title %></h3>
          </div>
          <p class="text-sm font-medium text-right">
            <%= job.years %> years @ <%= job.company %>
          </p>
        </button>
        <div
          id={"hs-basic-bordered-collapse-#{job.id}"}
          class="hs-accordion-content hidden w-full overflow-hidden transition-[height] duration-300"
          aria-labelledby={"hs-bordered-heading-#{job.id}"}
        >
          <div class="pb-4 px-5">
            <p class="text-gray-800 dark:text-neutral-200">
              <%= job.description %>
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def profile_link(assigns) do
    # slug =
    #   case site do
    #     :github ->
    #       url |> String.split("/") |> List.last()
    #
    #     :linkedin ->
    #       url |> String.trim_leading("https://linkedin.com/")
    #
    #     :website ->
    #       url
    #
    #     :resume ->
    #       "PDF Resume"
    #   end
    #
    # assigns = assign(assigns, :slug, slug)

    ~H"""
    <a
      href={@url}
      class="flex items-center gap-2 opacity-70 hover:opacity-100 transition-all duration-200"
      target="_blank"
    >
      <.icon name={@icon_name} size={20} />
    </a>
    """
  end
end
