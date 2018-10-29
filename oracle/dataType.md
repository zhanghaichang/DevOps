## oracle 数据类型


<table>
<thead>
<tr><th><span data-ttu-id="8d473-189">SQL Server 数据类型</span></th><th><span data-ttu-id="8d473-190">Oracle 数据类型</span></th></tr>
</thead>
<tbody>
<tr>
<td><span data-ttu-id="8d473-191">bigint</span></td>
<td><span data-ttu-id="8d473-192">NUMBER(19,0)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-193">binary(1-2000)</span></td>
<td><span data-ttu-id="8d473-194">RAW(1-2000)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-195">binary(2001-8000)</span></td>
<td><span data-ttu-id="8d473-196">BLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-197">bit</span></td>
<td><span data-ttu-id="8d473-198">NUMBER(1)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-199">char(1-2000)</span></td>
<td><span data-ttu-id="8d473-200">CHAR(1-2000)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-201">char(2001-4000)</span></td>
<td><span data-ttu-id="8d473-202">VARCHAR2(2001-4000)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-203">char(4001-8000)</span></td>
<td><span data-ttu-id="8d473-204">CLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-205">date</span></td>
<td><span data-ttu-id="8d473-206">DATE</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-207">datetime</span></td>
<td><span data-ttu-id="8d473-208">DATE</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-209">datetime2(0-7)</span></td>
<td><span data-ttu-id="8d473-210">TIMESTAMP(7)（对于 Oracle 9 和 Oracle 10）；VARCHAR(27)（对于 Oracle 8）</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-211">datetimeoffset(0-7)</span></td>
<td><span data-ttu-id="8d473-212">TIMESTAMP(7) WITH TIME ZONE（对于 Oracle 9 和 Oracle 10）；VARCHAR(34)（对于 Oracle 8）</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-213">decimal(1-38, 0-38)</span></td>
<td><span data-ttu-id="8d473-214">NUMBER(1-38, 0-38)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-215">float(53)</span></td>
<td><span data-ttu-id="8d473-216">FLOAT</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-217">float</span></td>
<td><span data-ttu-id="8d473-218">FLOAT</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-219">地理</span></td>
<td><span data-ttu-id="8d473-220">BLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-221">geometry</span></td>
<td><span data-ttu-id="8d473-222">BLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-223">hierarchyid</span></td>
<td><span data-ttu-id="8d473-224">BLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-225">图像</span></td>
<td><span data-ttu-id="8d473-226">BLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-227">int</span></td>
<td><span data-ttu-id="8d473-228">NUMBER(10,0)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-229">money</span></td>
<td><span data-ttu-id="8d473-230">NUMBER(19,4)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-231">nchar(1-1000)</span></td>
<td><span data-ttu-id="8d473-232">CHAR(1-1000)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-233">nchar(1001-4000)</span></td>
<td><span data-ttu-id="8d473-234">NCLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-235">ntext</span></td>
<td><span data-ttu-id="8d473-236">NCLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-237">numeric(1-38, 0-38)</span></td>
<td><span data-ttu-id="8d473-238">NUMBER(1-38, 0-38)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-239">nvarchar(1-1000)</span></td>
<td><span data-ttu-id="8d473-240">VARCHAR2(1-2000)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-241">nvarchar(1001-4000)</span></td>
<td><span data-ttu-id="8d473-242">NCLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-243">nvarchar(max)</span></td>
<td><span data-ttu-id="8d473-244">NCLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-245">real</span></td>
<td><span data-ttu-id="8d473-246">real</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-247">smalldatetime</span></td>
<td><span data-ttu-id="8d473-248">DATE</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-249">int</span></td>
<td><span data-ttu-id="8d473-250">NUMBER(5,0)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-251">smallmoney</span></td>
<td><span data-ttu-id="8d473-252">NUMBER(10,4)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-253">sql_variant</span></td>
<td><span data-ttu-id="8d473-254">N/A</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-255">sysname</span></td>
<td><span data-ttu-id="8d473-256">VARCHAR2(128)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-257">text</span></td>
<td><span data-ttu-id="8d473-258">CLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-259">time(0-7)</span></td>
<td><span data-ttu-id="8d473-260">VARCHAR(16)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-261">timestamp</span></td>
<td><span data-ttu-id="8d473-262">RAW(8)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-263">tinyint</span></td>
<td><span data-ttu-id="8d473-264">NUMBER(3,0)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-265">uniqueidentifier</span></td>
<td><span data-ttu-id="8d473-266">CHAR(38)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-267">varbinary(1-2000)</span></td>
<td><span data-ttu-id="8d473-268">RAW(1-2000)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-269">varbinary(2001-8000)</span></td>
<td><span data-ttu-id="8d473-270">BLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-271">varchar(1-4000)</span></td>
<td><span data-ttu-id="8d473-272">VARCHAR2(1-4000)</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-273">varchar(4001-8000)</span></td>
<td><span data-ttu-id="8d473-274">CLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-275">varbinary(max)</span></td>
<td><span data-ttu-id="8d473-276">BLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-277">varchar(max)</span></td>
<td><span data-ttu-id="8d473-278">CLOB</span></td>
</tr>
<tr>
<td><span data-ttu-id="8d473-279">xml</span></td>
<td><span data-ttu-id="8d473-280">NCLOB</span></td>
</tr>
</tbody>
</table>
