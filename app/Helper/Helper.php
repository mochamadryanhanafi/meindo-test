<?php

if (!function_exists('prepare_locations_for_insert')) {
    function prepare_locations_for_insert(int $submissionId, string $jsonString): array
    {
        $ids = json_decode($jsonString, true);
        if (!is_array($ids)) return [];
        
        return array_map(function($id) use ($submissionId) {
            return ['submission_id' => $submissionId, 'location_id' => (int)$id];
        }, $ids);
    }
}