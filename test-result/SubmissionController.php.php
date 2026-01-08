<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SubmissionController extends Controller
{
    /**
     * Retrieve submissions with locations suitable for DataTable.
     * strictly using DB Query Builder (No Eloquent).
     */
    public function index(Request $request)
    {
        // 1. Parameter Handling
        $limit = (int) $request->input('limit', 10);
        $offset = (int) $request->input('offset', 0);
        $search = $request->input('search');
        $sortBy = $request->input('sort_by', 'id');
        $sortDir = strtolower($request->input('sort_dir', 'asc')) === 'desc' ? 'desc' : 'asc';

        // Whitelist kolom sort untuk keamanan (mencegah SQL Injection)
        $allowedSorts = ['id', 'submission_type', 'object_id'];
        if (!in_array($sortBy, $allowedSorts)) {
            $sortBy = 'id';
        }

        // 2. Base Query
        $query = DB::table('submissions as s')
            ->select([
                's.id',
                's.submission_type',
                's.object_id',
                DB::raw('GROUP_CONCAT(l.name ORDER BY l.name SEPARATOR ", ") as location_names')
            ])
            ->leftJoin('submission_locations as sl', 's.id', '=', 'sl.submission_id')
            ->leftJoin('locations as l', 'sl.location_id', '=', 'l.id');

        // 3. Search Implementation
        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('s.submission_type', 'LIKE', "%{$search}%")
                  ->orWhere('l.name', 'LIKE', "%{$search}%");
            });
        }

        // 4. Grouping (Wajib karena ada GROUP_CONCAT)
        $query->groupBy('s.id', 's.submission_type', 's.object_id');

        // 5. Sorting
        $query->orderBy('s.' . $sortBy, $sortDir);

        // 6. Manual Pagination & Total Count
        // Kita perlu membungkus query utama untuk mendapatkan hitungan total yang akurat setelah GROUP BY
        $countQuery = DB::table(DB::raw("({$query->toSql()}) as sub"))
            ->mergeBindings($query); 
            
        $total = $countQuery->count();

        // Ambil data
        $data = $query->offset($offset)
            ->limit($limit)
            ->get();

        // 7. Response
        return response()->json([
            'status' => 'success',
            'data' => $data,
            'meta' => [
                'total' => $total,
                'limit' => $limit,
                'offset' => $offset,
                'search' => $search,
                'sort' => $sortBy . ':' . $sortDir
            ]
        ]);
    }
}