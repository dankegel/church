<?php
/**
 * @file
 * repeating_calendar_example.features.inc
 */

/**
 * Implements hook_views_api().
 */
function repeating_calendar_example_views_api($module = NULL, $api = NULL) {
  return array("api" => "3.0");
}

/**
 * Implements hook_node_info().
 */
function repeating_calendar_example_node_info() {
  $items = array(
    'myevents' => array(
      'name' => t('myevents'),
      'base' => 'node_content',
      'description' => t('x'),
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
  );
  return $items;
}
